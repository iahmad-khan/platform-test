# platform-test

This repository contains the containerized application and modular Infrastructure-as-Code (IaC) for the **platform-test** project. It follows SRE best practices for multi-environment deployments and secure networking.

## Repository Structure

```


├── app
│   ├── app.py
│   ├── Dockerfile
│   ├── README.MD
│   └── requirements.txt
├── README.md
└── terraform-iac
    ├── environments
    │   ├── dev
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   ├── production
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   └── staging
    │       ├── main.tf
    │       └── variables.tf
    ├── modules
    │   ├── compute
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   ├── database
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   ├── security
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   └── vpc
    │       ├── main.tf
    │       ├── outputs.tf
    │       └── variables.tf
    └── README.md



```


The project is divided into the application source and the Terraform infrastructure modules.

### 1. `/app`
The core service layer for the **platform-test** deployment.
* **`app.py`**: Python backend handling application logic and API endpoints.
* **`Dockerfile`**: Defines the containerized environment for consistent local-to-cloud deployment.
* **`requirements.txt`**: List of Python dependencies (FastAPI, Flask, etc.).
* **`README.MD`**: Specific instructions for running and testing the application locally.


### 2. `/terraform-iac`
Modular AWS infrastructure management.


#### 🔹 `modules/`
Reusable infrastructure components (The "Building Blocks"):
* **`vpc`**: Handles network isolation (Public/Private subnets), NAT Gateways, and Route Tables.
* **`security`**: Manages Security Groups (Firewalls) and IAM policies.
* **`compute`**: Logic for provisioning EC2 instances or EKS worker nodes.
* **`database`**: Configures RDS instances with Multi-AZ support and encryption.


#### 🔹 `environments/`
State-specific configurations for the **platform-test** lifecycle:
* **`dev`**: Sandbox environment for rapid iteration.
* **`staging`**: High-fidelity pre-production testing.
* **`production`**: Live environment with maximum security and redundancy.

---


## Deployment Workflow

### Prerequisites
- **AWS CLI**: Configured with valid credentials (`aws configure`).
- **Terraform**: Version 1.0+ installed.
- **Docker**: For building the application image.

### 1. Local Testing
To test the **platform-test** app locally:

```
cd app
docker build -t platform-test:latest .
docker run -p 8000:8000 platform-test:latest

````


### 2. Provisioning Infrastructure
To deploy the infrastructure for a specific environment (e.g., dev):


```
cd terraform-iac/environments/dev
terraform init
terraform plan
terraform apply
```

## CI/CD Automation (GitHub Actions)

The infrastructure for **platform-test** is managed via automated workflows located in `.github/workflows/`. This ensures that every change to the environment is reviewed, validated, and audited.

### Workflow Pipeline

| Workflow | Trigger | Action |
| :--- | :--- | :--- |
| **`terraform-pr.yml`** | **Pull Request** to `main` | Runs `terraform fmt`, `init`, and `plan`. Posts the plan output as a PR comment for review. |
| **`terraform-apply-auto.yml`** | **Push** to `main` | Automatically applies changes to **Dev** environment. |
| **`terraform-apply-prod.yml`** | **Manual Trigger** | Deployment to **Production**. Requires a manual approval gate and successful Staging validation. |


### Key Automation Features

* **Infrastructure Linting**: Every PR is automatically checked for proper formatting (`terraform fmt`) to maintain code quality.
* **Plan Visibility**: The PR workflow provides a transparent view of exactly what resources will be created, modified, or destroyed before any code is merged into the trunk.
* **State Locking Protection**: Workflows respect DynamoDB state locking, preventing race conditions during concurrent deployments.

### How to Trigger a Deployment

1.  **Develop**: Create a feature branch and commit your Terraform changes.
2.  **Verify**: Open a Pull Request. Check the GitHub Actions tab or PR comments for the `terraform plan` output.
3.  **Merge**: Once approved, merge to `main`. The `terraform-apply-auto` will automatically update lower environments.
4.  **Promote**: For Production, navigate to the **Actions** tab, select `terraform-apply-prod`, and click "**Run workflow**."

---

## Platform Security & Best Practices

* **Network Isolation**: Database reside in **Private Subnets**. They are unreachable from the public internet.
* **Least Privilege**: Security Groups are restricted to specific ports; the App can talk to the DB, but the outside world cannot.
* **Secret Management**: No hardcoded credentials. 
* **Remote State**: Terraform state is stored in encrypted S3 bucket with naitve locking ( dynamodb table not needed )

