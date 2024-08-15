# Project Overview

This project consists of two Python web applications, **numbers-api** and **microservices**, both developed using FastAPI. Each application has its own Dockerfile, Helm chart for deployment, and shared dependencies on a base Helm chart.

## Directory Structure
```csharp
/
├── README.md
├── apps
│   ├── apps-dev.yaml
│   └── apps-prod.yaml
├── forwarder
│   ├── app
│   │   ├── main.py
│   │   └── requirements.txt
│   └── dockerfile
├── numbers-api
│   ├── app
│   │   ├── main.py
│   │   └── requirements.txt
│   └── dockerfile
├── semVersioning
│   └── git_update.sh
└── terraform
    ├── ecrInitSetup
    │   └── main.tf
    └── eksCreation
        ├── argocd.tf
        ├── eks.tf
        ├── helm-provider.tf
        ├── igw.tf
        ├── image-updater.tf
        ├── locals.tf
        ├── nat.tf
        ├── nodes.tf
        ├── pod-Identity-addon.tf
        ├── provider.tf
        ├── routes.tf
        ├── subnet.tf
        ├── values
        │   ├── argocd.yaml
        │   └── image-updater.yaml
        ├── variables.tf
        └── vpc.tf
```


## Components

### Applications
- **numbers-api**: A FastAPI-based web application that listens on 2 routes:
/odd: returns a random odd number from the range of 1-20.<br>
/even: returns a random even number from the range of 1-20.
- **forwarder**: A FastAPI-based web application that sends an api request to the given url from an environment variable named `API_URL` and returns the response.

### ArgoCD
- ArgoCD application yaml files, using app of apps concept for deoloying multiple applications from a single ArgoCD Application .
- Pointing the parent app to another repo we are using to store the child application files and hwlm charts for each application.
- using image-updater to look for any new image tags in ecr repos, commiting this change to the charts repo so that ArgoCD can deploy it on the cluster.

### Dockerfiles
- Each application has its own Dockerfile for containerization based on `python:3.9-slim` image.

### Terraform
- **eksCreation**: Terraform module for creating eks k8s cluster + configuring some ArgoCD resoucres.
- **ecrInitSetup**: Terraform module for creating 2 ecr repos we need for storing application images for numbers-api and forwarder application.

### GitHub Workflow

#### Workflow Overview
- **eks-creation**: 
- A GitHub Actions workflow `EKS creation` creating eks k8s cluster.
- this Workflow is using eks-creation Terraform module.
- The workflow is triggered manualy.
- The workflow creates multiple cloud resources (node group, vpc, subnets, internet gway, iam roles etc..), install nginx ingress controller and setting up kubectl in order the cluster to work properly.
- AWS credentials are stored as GitHub Actions secrets `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.

- **argo-install**: 
- A GitHub Actions workflow `Install ArgoCD` installing ArgoCD on the cluster + applying the parent ArgoCD application on the cluster.
- this Workflow is using builtin helm chart for installing Argocd `https://argoproj.github.io/argo-helm` .
- this Workflow applys the app of apps principle and deploy all the apps on the cluster, after watching the charts repo for apllications to deploy.
- The workflow is triggered manualy.
- AWS credentials are stored as GitHub Actions secrets `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.

- **ecr-creation**: 
- A GitHub Actions workflow `ECR repo creation` creating 2 ECR repos on aws to store images, one for numbers-api app and one for forwarder app.
- this Workflow is using ecr-creation Terraform module.
- The workflow is triggered manualy.
- AWS credentials are stored as GitHub Actions secrets `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.

- **build-service**:
- A GitHub Actions workflow `build service` running a simple ci pipline, building docker images for both applications and push it to each repo respectivly.
- The workflow is triggered automaticly on push to main branch.
- AWS credentials are stored as GitHub Actions secrets `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.

#### Running GitHub Actions Workflow notes

1. you must run ECR repo creation and ECR repo creation first, then Install ArgoCD in order for things to work.
2. cluster creation will take about 20-25 minutes.


