# Technion Final Project - Deploying an Application on a KIND Cluster 

This project combines a Python web application with Docker, orchestrated using **Helm** and **Terraform** for deployment. The application is containerized and deployed on a Kubernetes cluster, managed via **Helm**, and infrastructure is provisioned with **Terraform**.

## Overview

- **Python Web Application**: A simple web app built with Python and Flask (or similar framework).
- **Docker**: The app is containerized using Docker.
- **Helm**: Helm charts are used to manage the Kubernetes deployment.
- **Terraform**: Terraform is used to provision infrastructure (e.g., EC2 instances, Kubernetes clusters) and manage the deployment.

## Prerequisites

- Docker
- Kubernetes Cluster (via `kind`, EKS, or other Kubernetes providers)
- Helm 3.x
- Terraform
- AWS CLI
- kubectl

## Project Structure

```plaintext
.
├── Dockerfile               # Dockerfile for the Python application
├── app.py                   # Python application code
├── requirements.txt         # Python dependencies
├── infra/                   # Terraform files for provisioning infrastructure
│   ├── main.tf              # Terraform configuration files
├── helm-charts/             # Helm charts for Kubernetes deployment
└── README.md                # This file
```

## Setup

### 1. **Terraform Setup**

Terraform is used to provision the infrastructure. This includes provisioning an EC2 instance and Kubernetes resources. Here’s how you can use Terraform to set up your infrastructure.

#### Initialize Terraform

In the `infra/` directory, initialize Terraform:

```bash
cd infraterraform init
```

#### Plan Terraform Deployment

Run the following to see what changes will be made:

```bash
terraform plan
```

#### Apply Terraform Configuration

Once you’re satisfied with the plan, apply it to provision your resources:

```bash
terraform apply
```

### 2. **Docker Setup**

The Python application is containerized using Docker. To build and run the Docker image:

#### Build Docker Image

```bash
docker build -t myapp .
```

#### Run the Application Locally

To run the app locally (without Kubernetes):

```bash
docker run -p 5001:5001 myapp
```

The application will be accessible at [http://localhost:5001](http://localhost:5001).

### 3. **Helm Setup**

Once your infrastructure is provisioned, you can deploy the application to your Kubernetes cluster using Helm.

#### Install Helm Chart for Python App

To install the Python web app in Kubernetes, use the following Helm commands:

```bash
# Install the Helm chart (Ensure your Kubernetes cluster is accessible)
cd helm/flask-app
helm install flask-app .
```

#### Upgrade Helm Release

If you make changes to the Helm chart or app, you can upgrade the release with:

```bash
helm upgrade flask-app .
```

### 4. **Deployment Workflow with GitOps**

For automated deployment, you can use a GitOps workflow with **ArgoCD** or similar tools to automatically sync your infrastructure changes and app deployments. You can deploy your Helm charts using ArgoCD by defining the chart repository in your ArgoCD configuration.

## How the Project Works

### 1. **Terraform** provisions the infrastructure:
- EC2 instances or other infrastructure as needed (e.g., using **AWS EKS** or **Kind** for Kubernetes clusters).
- Kubernetes resources (e.g., namespaces, deployments) are created via **Helm** for deployment.

### 2. **Docker** builds and runs the Python application:
- The app is packaged as a Docker container.
- Runs on the Kubernetes cluster via a **Helm** deployment.

### 3. **Helm** deploys the app to Kubernetes:
- The application is managed as a Helm release on your Kubernetes cluster.

### 4. **GitOps** for continuous deployment:
- You can automate deployments using a GitOps approach (e.g., ArgoCD) by linking your Kubernetes cluster with your repository.

## Example Workflow

1. **Apply Infrastructure Changes** with Terraform:  
   Provision the required infrastructure (EC2, Kubernetes) via Terraform.

   ```bash
   terraform apply
   ```

2. **Build Docker Image** and Push to Container Registry (optional):
   Build the Docker image for your app.

   ```bash
   docker build -t myapp . 
   ```

   Push the image to a container registry (e.g., Docker Hub, AWS ECR).

3. **Deploy with Helm**:
   Deploy the application to your Kubernetes cluster using Helm:

   ```bash
   helm install flask-app ./helm/flask-app
   ```

4. **Automate Deployment** using ArgoCD or other GitOps tools:
   - Connect your repository to ArgoCD to trigger automatic deployments when code changes are pushed.

## Cleanup

To remove the infrastructure created by Terraform:

```bash
terraform destroy
```

To remove the application deployed via Helm:

```bash
helm uninstall flask-app 
```

## License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

---

### Key Enhancements:
- **Docker**: Running the application in a container for isolated environments.
- **Helm**: Kubernetes deployments are managed and versioned using Helm charts.
- **Terraform**: Infrastructure provisioning for cloud resources like EC2 and Kubernetes clusters.
- **GitOps**: Optionally deploy the application automatically using GitOps principles (e.g., with ArgoCD).

---

This README provides a concise yet comprehensive overview of the entire project, covering setup and usage for each component (Docker, Terraform, Helm, etc.), and gives users a clear understanding of how to deploy and manage the system. Let me know if you need more adjustments or clarifications!
