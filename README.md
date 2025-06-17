# Flask Hello World - CI/CD Demo Application

A simple Flask application demonstrating CI/CD pipeline integration with GitHub Actions, Docker, and Kubernetes deployment options.

## 🚀 Application Overview

This is a minimal Flask web application that returns "Hello, World!" when accessed. It's designed to demonstrate:

- **Containerization** with Docker
- **Automated CI/CD** with GitHub Actions
- **Kubernetes deployment** with both raw manifests and Terraform
- **Container registry** integration with DockerHub

## 📋 Table of Contents

- [Quick Start](#quick-start)
- [Local Development](#local-development)
- [CI/CD Pipeline](#cicd-pipeline)
- [Deployment Options](#deployment-options)
  - [Method 1: kubectl with YAML Manifests](#method-1-kubectl-with-yaml-manifests)
  - [Method 2: Terraform Infrastructure as Code](#method-2-terraform-infrastructure-as-code)
- [Accessing the Application](#accessing-the-application)
- [Project Structure](#project-structure)

## 🏃 Quick Start

### Prerequisites

- Docker
- Kubernetes cluster (minikube or kind)
- kubectl configured

**For Terraform deployment, additionally:**
- Terraform installed (v1.0+)

### 1. Clone and Run Locally

```bash
git clone https://github.com/9shivamsharma/assignment-demo.git
cd assignment-demo

# Run with Docker
docker build -t flask-hello-world .
docker run -p 8000:8000 flask-hello-world
```

### 2. Deploy to Kubernetes

**Choose one deployment method:**

**Method A: Using kubectl and YAML manifests**
```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

**Method B: Using Terraform (Infrastructure as Code)**
```bash
cd terraform
terraform init
terraform plan
terraform apply
```
### 3. Access the Application

```bash
# Get the service URL
kubectl get svc flask-service

# Access via NodePort (replace with your cluster IP)
curl http://<cluster-ip>:30036
```

## 💻 Local Development

### Running the Application

**Using Docker**
```bash
# Build the image
docker build -t flask-hello-world .

# Run the container
docker run -p 8000:8000 flask-hello-world

# Access at http://localhost:8000
```

## 🔄 CI/CD Pipeline

The project uses GitHub Actions for automated CI/CD with the following workflow:

### Current Pipeline (`.github/workflows/docker-publish.yml`)

**Triggers:**
- Push to `master` branch

**Steps:**
1. **Checkout code** - Retrieves the latest code
2. **Docker Hub login** - Authenticates with DockerHub
3. **Build & Push** - Builds Docker image and pushes with `latest` tag

**Current Image Tagging:**
- All builds are tagged as `latest`
- Image: `shivam432000/flask-hello-world:latest`

### Required Secrets

Configure these secrets in your GitHub repository:

```
DOCKER_USERNAME - Your DockerHub username
DOCKER_PASSWORD - Your DockerHub password or access token
```

### Pipeline Status

You can monitor the pipeline status in the GitHub Actions tab of your repository.

## 🚀 Deployment Options

This project supports two main Kubernetes deployment approaches. Choose the one that best fits your workflow:

### Method 1: kubectl with YAML Manifests

**Simple declarative deployment using standard Kubernetes manifests.**

```bash
# Apply the deployment
kubectl apply -f deployment.yaml

# Apply the service
kubectl apply -f service.yaml

# Check deployment status
kubectl get deployments
kubectl get pods
kubectl get services
```

**Configuration:**
- **Replicas:** 2 pods
- **Image:** `shivam432000/flask-hello-world:0.1` (as defined in deployment.yaml)
- **Service Type:** NodePort
- **External Port:** 30036

**Cleanup:**
```bash
kubectl delete -f deployment.yaml
kubectl delete -f service.yaml
```

### Method 2: Terraform Infrastructure as Code

**Infrastructure as Code approach with state management and advanced features.**

```bash
cd terraform

# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the changes
terraform apply

# View outputs
terraform output
```

**Configuration:**
- **Replicas:** 2 pods (configurable via variables)
- **Image:** `shivam432000/flask-hello-world:latest` (configurable)
- **Service Type:** NodePort
- **External Port:** 30036 (configurable)


**Customization with Variables:**
```bash
# Deploy with custom configuration
terraform apply \
  -var="replica_count=3" \
  -var="node_port=30037" \
  -var="image_tag=v1.0.0"

# Or create terraform.tfvars file
echo 'replica_count = 3' > terraform.tfvars
echo 'node_port = 30037' >> terraform.tfvars
terraform apply
```

**Available Variables:**
- `image_name` - Docker image name (default: `shivam432000/flask-hello-world`)
- `image_tag` - Docker image tag (default: `latest`)
- `replica_count` - Number of pod replicas (default: `2`)
- `node_port` - NodePort for external access (default: `30036`)

**Cleanup:**
```bash
terraform destroy
```

### Local Development Option

**For local development and testing only:**

```bash
# Pull the latest image
docker pull shivam432000/flask-hello-world:latest

# Run the container locally
docker run -d -p 8000:8000 --name flask-app shivam432000/flask-hello-world:latest

# Access at http://localhost:8000

# Cleanup
docker stop flask-app
docker rm flask-app
```

## 🌐 Accessing the Application

### Local Access
- **Docker:** http://localhost:8000

### Kubernetes Access

**NodePort Service:**
```bash
# Get cluster IP
kubectl get nodes -o wide

# Access the application
curl http://<node-ip>:30036
```

**Port Forwarding (for testing):**
```bash
# Forward local port to service
kubectl port-forward service/flask-service 8080:80

# Access at http://localhost:8080
```

**Minikube Access:**
```bash
# Get the service URL
minikube service flask-service --url
```

## 📁 Project Structure

```
assignment-demo/
├── .github/
│   └── workflows/
│       └── docker-publish.yml    # CI/CD pipeline
├── app/
│   ├── __init__.py
│   ├── main.py                   # Flask application
│   └── requirements.txt          # Python dependencies
├── terraform/
│   ├── main.tf                   # Terraform main configuration
│   ├── variables.tf              # Terraform variables
│   ├── terraform.tfstate         # Terraform state (auto-generated)
│   └── terraform.tfstate.backup  # Terraform state backup
├── Dockerfile                    # Container definition
├── deployment.yaml               # Kubernetes deployment manifest
├── service.yaml                  # Kubernetes service manifest
├── requirements.txt              # Root Python dependencies
├── .dockerignore                 # Docker ignore rules
└── README.md                     # This file
```

### Enhanced Image Tagging Strategy

**Current Limitation:** All images use the `latest` tag, making it difficult to:
- Track specific versions
- Rollback to previous versions
- Identify which commit corresponds to which image

