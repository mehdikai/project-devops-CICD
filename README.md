# project-devops-CICD

A comprehensive DevOps CI/CD project demonstrating modern delivery pipelines using Docker, Jenkins, Ansible, Terraform, and Kubernetes.

## Overview

This repository contains a complete DevOps automation stack for building, testing, and deploying containerized applications. It showcases infrastructure as code, configuration management, containerization, and orchestration practices used in production environments.

## Project Documentation

- **[Project Report](Rapport_projet_devops.pdf)** - Detailed documentation of architecture, design decisions, and implementation
- **[Pipeline Demo Video](Pipeline%20running.mp4)** - Visual demonstration of the CI/CD pipeline in action

## Repository Structure

```
├── Ansible/              # Configuration management and deployment automation
├── Terraform/            # Infrastructure provisioning (IaC)
├── Kubernetes/           # Container orchestration manifests
├── docker/               # Container images and Dockerfiles
├── jenkins/              # CI/CD pipeline definitions
├── age-calculator/       # Demo application
├── Rapport_projet_devops.pdf
└── Pipeline running.mp4
```

### Directory Details

- **Ansible/** - Playbooks and roles for server configuration and application deployment
- **Terraform/** - Infrastructure provisioning scripts for cloud resources and networking
- **Kubernetes/** - Deployment manifests, services, and ingress configurations
- **docker/** - Dockerfiles and build scripts for containerizing applications
- **jenkins/** - Jenkinsfiles and pipeline configurations for automated CI/CD
- **age-calculator/** - Sample application demonstrating the complete pipeline

## Prerequisites

- **Git** - Version control
- **Docker** - Container runtime and image building
- **Jenkins** - CI/CD automation server
- **kubectl** - Kubernetes command-line tool
- **Terraform** - Infrastructure as code tool
- **Ansible** - Configuration management tool
- **Access Requirements:**
  - Docker registry (Docker Hub, GitHub Container Registry, ECR)
  - Kubernetes cluster (minikube, kind, or cloud provider)
  - Cloud provider credentials (for Terraform)
  - SSH access to target hosts (for Ansible)

## Quick Start

### 1. Build Container Images

```bash
cd docker/
docker build -t <registry>/<repo>:<tag> .
docker push <registry>/<repo>:<tag>
```

### 2. Provision Infrastructure

```bash
cd Terraform/
terraform init
terraform plan
terraform apply
```

### 3. Configure with Ansible

```bash
cd Ansible/
# Update inventory file with your hosts
ansible-playbook -i inventory playbook.yml
```

### 4. Deploy to Kubernetes

```bash
cd Kubernetes/
kubectl apply -f .
```

### 5. Run CI/CD Pipeline

Configure Jenkins with the pipeline definition from the `jenkins/` directory and trigger a build.

## Workflow

1. **Build** - Application code is built and containerized
2. **Test** - Automated tests run against the container
3. **Push** - Verified images are pushed to the registry
4. **Infrastructure** - Terraform provisions required cloud resources
5. **Configure** - Ansible configures servers and dependencies
6. **Deploy** - Kubernetes manifests deploy the application
7. **Validate** - Health checks and smoke tests confirm deployment

## Configuration

### Credentials Setup

Configure the following credentials in your environment:
- Cloud provider API keys (AWS, GCP, Azure)
- Docker registry credentials
- Jenkins credentials for GitHub/GitLab
- Kubernetes cluster access tokens
- Ansible SSH keys

**Note:** Credentials are not stored in this repository. Use environment variables, Jenkins credentials store, or a secrets manager.

## Getting Started

1. Review the [project report](Rapport_projet_devops.pdf) for architecture details
2. Watch the [demo video](Pipeline%20running.mp4) to see the pipeline in action
3. Explore each directory starting with `docker/` and `jenkins/`
4. Update configuration files with your environment-specific values
5. Run through the Quick Start steps above

## Important Notes

- No credentials or secrets are included in this repository
- Update Terraform variables before provisioning infrastructure
- Review Ansible inventory files and update with your target hosts
- Kubernetes manifests may need namespace and resource adjustments
- Check cloud provider region settings to avoid unexpected billing

## Contributing

Contributions are welcome! To improve this project:

- Add detailed README files in each subdirectory
- Include example configuration files with placeholder values
- Document environment variables and required secrets
- Create architecture diagrams showing the complete flow
- Add troubleshooting guides for common issues

## Future Enhancements

- Helm charts for easier Kubernetes deployments
- GitOps workflow with ArgoCD or Flux
- Monitoring and logging integration (Prometheus, Grafana, ELK)
- Security scanning in the pipeline
- Multi-environment deployment strategies

## Author

**mehdikai** - [GitHub Profile](https://github.com/mehdikai)

## License
MIT licence

---

For questions or issues, please open an issue in this repository.
