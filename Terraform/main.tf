terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# 🔹 Define sensitive variables
variable "subscription_id" { default = "" }
variable "client_id" { default = "" }
variable "client_secret" { default = "" }
variable "tenant_id" { default = "" }

# 🔹 Create Resource Group (Updated Name)
resource "azurerm_resource_group" "rg" {
  name     = "rg-devops-new"  # ✅ Changed from "rg-devops" to "rg-devops-new"
  location = "East US"
}

# 🔹 Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-devops"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}

# 🔹 Create Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-devops"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 🔹 Create Network Security Group (NSG)
resource "azurerm_network_security_group" "nsg" {
  name                = "devops-nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  # Allow SSH (Port 22)
  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# 🔹 Create Public IPs (Static)
resource "azurerm_public_ip" "pip_master" {
  name                = "pip-master"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "pip_worker" {
  name                = "pip-worker"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
}

# 🔹 Create Network Interfaces (Attach to NSG)
resource "azurerm_network_interface" "nic_master" {
  name                = "nic-master"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.10"
    public_ip_address_id          = azurerm_public_ip.pip_master.id
  }
}

resource "azurerm_network_interface" "nic_worker" {
  name                = "nic-worker"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.11"
    public_ip_address_id          = azurerm_public_ip.pip_worker.id
  }
}

# 🔹 Attach NSG to Network Interfaces
resource "azurerm_network_interface_security_group_association" "master_nsg" {
  network_interface_id      = azurerm_network_interface.nic_master.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface_security_group_association" "worker_nsg" {
  network_interface_id      = azurerm_network_interface.nic_worker.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# 🔹 Create Master Node (2 vCPUs, 4GB RAM)
resource "azurerm_linux_virtual_machine" "vm_master" {
  name                = "k8s-master"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2ms" # 2 vCPUs, 8GB RAM
  admin_username      = "azureuser"

  network_interface_ids = [azurerm_network_interface.nic_master.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh_key/id_rsa.pub") # ✅ Correct path
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = {
    Role        = "Master"
    Environment = "Dev"
    Project     = "DevOps"
  }
}

# 🔹 Create Worker Node (1 vCPU, 2GB RAM)
resource "azurerm_linux_virtual_machine" "vm_worker" {
  name                = "k8s-worker"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2s" # 1 vCPU, 2GB RAM
  admin_username      = "azureuser"

  network_interface_ids = [azurerm_network_interface.nic_worker.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh_key/id_rsa.pub") # ✅ Correct path
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = {
    Role        = "Worker"
    Environment = "Dev"
    Project     = "DevOps"
  }
}
