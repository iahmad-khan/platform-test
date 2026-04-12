# Terraform Infrastructure as Code (IaC)

This repository contains a modular and environment-based Terraform setup for provisioning AWS infrastructure following best practices.

---

## Repository Structure

```
terraform-iac/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── production/
└── modules/
    ├── vpc/
    ├── security/
    ├── compute/
    └── database/
```

---

## Architecture Overview

The infrastructure is organized into:

### 1. Environments

Each environment (`dev`, `staging`, `production`) contains its own Terraform configuration:

* Isolated state and configuration
* Environment-specific variables
* Independent deployment lifecycle

### 2. Reusable Modules

Core infrastructure components are abstracted into reusable modules:

* **vpc** → VPC, subnets (public/private), routing
* **security** → Security groups with least-privilege rules
* **compute** → EC2 instance for application workload
* **database** → RDS MySQL instance (private, secured)

---

## Getting Started ( local testing )

### Prerequisites

* Terraform >= 1.5
* AWS CLI configured
* Valid AWS credentials

---

### Initialize Terraform

```bash
cd terraform-iac/environments/dev
terraform init
```

---

### Plan Changes

```bash
terraform plan
```

---

### Apply Changes

```bash
terraform apply
```

---

## Environments

Each environment is fully isolated and follows the same structure:

| Environment | Purpose        |
| ----------- | -------------- |
| dev         | Development    |
| staging     | Pre-production |
| production  | Production     |

---

## Security Best Practices

This setup includes:

* Private subnet for database (no public exposure)
* Security groups with restricted access:

  * HTTP (80) open to public for web tier
  * SSH restricted to specific IPs
  * Database access limited to application layer only
* No hardcoded secrets (use variables or secret managers)

---

##  CI/CD Overview

The repository is integrated with GitHub Actions:

### Pull Requests

* Runs:

  * `terraform fmt`
  * `terraform validate`
  * `tflint`
  * `terraform plan` 
* Plan output is posted as a PR comment

### Merge to `main`

* Runs simulated `terraform apply` (via `plan`) on `dev` environment

### Manual Apply (Optional, for staging and prod )

* Environment selection via workflow dispatch
* Approval-gated deployment per environment

---

## Reusability

Modules are designed to be reusable across environments:

* Parameterized inputs (CIDR, AZs, etc.)
* Outputs used for cross-module dependencies
* Clear separation of concerns



---

## Future Improvements

* Introduce ALB + Auto Scaling Group for AutoScaling
* Add multi-AZ support across all modules
* Consider using elastic container service instead of EC2 with docker 
* Use seprate git repo per TF module instead of shared repo
* Tag TF modules, this will selectivly expose new changes in modules to each envrionment in isolation
* Setup Github to AWS auth ( terraform ) using OIDC instead of AWS Secret Keys

---

## Contributing

1. Create a feature branch
2. Open a Pull Request
3. Ensure CI checks pass
4. Get approval before merge

---

## License

This project is for educational and demonstration purposes.
