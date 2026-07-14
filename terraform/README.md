# AWS Infrastructure with Terraform 

This project demonstrates how to provision a complete AWS infrastructure using Terraform with a modular approach.

##  Project Overview
I built a reusable and scalable infrastructure setup using Terraform modules:
- VPC (Networking layer)
- EC2 (Compute layer)

The goal was to follow Infrastructure as Code (IaC) best practices and avoid manual configuration in AWS.


##  Architecture
- Custom VPC
- Public & Private Subnets
- Internet Gateway
- Route Tables & Associations
- Security Groups (SSH & HTTP)
- EC2 Instance deployed in public subnet


##  Tech Stack
- Terraform
- AWS (EC2, VPC, IAM)
- Git & GitHub


##  Project Structure
.
├── main.tf
├── variables.tf
├── .gitignore
├── module/
│ ├── VPC/
│ └── EC2/


---

##  Workflow
1. Initialize Terraform
   ```bash
   terraform init

2. Validate configuration
    terraform validate

3. Preview changes
    terraform plan

4. Apply infrastructure
    terraform apply


## Security Best Practices
Sensitive files like .tfstate, .tfvars, .env are ignored using .gitignore
Used variables instead of hardcoding values
Modular design for reusability


## Key Learnings
Terraform module structure and reusability
Passing outputs between modules
Debugging real-world Terraform errors
AWS networking fundamentals (VPC, Subnet, IGW, SG)

## Future Improvements
Add S3 backend for remote state management
Implement CI/CD pipeline
Add Load Balancer and Auto Scaling