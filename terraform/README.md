# CloudForge — EKS Cluster on AWS via Terraform

Modular Terraform project that provisions a new VPC + Amazon EKS cluster + managed node group, using a production-style module structure.

---

## Architecture

```
Internet
   │
   ▼
┌─────────────────────────── VPC (10.0.0.0/16) ───────────────────────────┐
│                                                                          │
│   Public Subnets (2 AZ)              Private Subnets (2 AZ)             │
│   ┌──────────────┐                    ┌──────────────────────┐         │
│   │ NAT Gateway   │ ─────────────────▶│  EKS Worker Nodes     │         │
│   │ IGW           │                    │  (Managed Node Group) │         │
│   └──────────────┘                    └──────────────────────┘         │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
                         EKS Control Plane (AWS managed)
                                    │
                                    ▼
                         OIDC Provider (for IRSA)
```

- Worker nodes live in **private subnets**; outbound internet access is provided via the NAT Gateway.
- The EKS control plane is AWS-managed and spans both public and private subnets.
- An OIDC provider is set up to support future IRSA use cases (ALB controller, EBS CSI driver, cluster-autoscaler).

---

## Project Structure

```
terraform/
├── main.tf                     # root - calls the vpc & eks modules
├── variables.tf                # root-level input variables
├── outputs.tf                  # root-level outputs
├── providers.tf                # AWS + TLS provider config
├── terraform.tfvars.example    # sample values (copy to terraform.tfvars)
├── terraform.tfvars             # your actual values (git-ignored)
└── modules/
    ├── vpc/
    │   ├── main.tf              # VPC, subnets, IGW, NAT, route tables
    │   ├── variables.tf
    │   └── outputs.tf
    └── eks/
        ├── main.tf              # EKS cluster, OIDC provider, node group
        ├── iam.tf                # cluster IAM role + node IAM role
        ├── variables.tf
        └── outputs.tf
```

---

## Prerequisites

| Tool | Version | Check |
|---|---|---|
| Terraform | >= 1.5.0 | `terraform version` |
| AWS CLI | v2 | `aws --version` |
| kubectl | latest | `kubectl version --client` |
| AWS credentials configured | — | `aws configure` |

The AWS IAM user/role you use needs permissions for EKS, EC2, VPC, and IAM (create/attach roles).

---

## Setup

```powershell
cd terraform
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars with your values (region, project_name, instance types)

terraform init
terraform plan
terraform apply
```

The apply step takes **10–15 minutes** — the EKS control plane takes time to provision.

### Connect kubectl

```powershell
aws eks update-kubeconfig --region ap-south-1 --name gaurav-eks-demo
kubectl get nodes
```

(You can also get the exact command from `terraform output configure_kubectl`.)

---

## Module Contract

**`modules/vpc`**
| Direction | Name |
|---|---|
| Input | `vpc_cidr`, `azs`, `private_subnet_cidrs`, `public_subnet_cidrs`, `cluster_name` |
| Output | `vpc_id`, `private_subnet_ids`, `public_subnet_ids`, `all_subnet_ids` |

**`modules/eks`**
| Direction | Name |
|---|---|
| Input | `cluster_name`, `cluster_version`, `subnet_ids`, `node_subnet_ids`, node sizing |
| Output | `cluster_endpoint`, `cluster_certificate_authority_data`, `oidc_provider_arn`, `node_role_arn` |

The root `main.tf` wires the VPC module's outputs into the EKS module's inputs (e.g. `module.vpc.private_subnet_ids` → `node_subnet_ids`).

---

## Troubleshooting

**`Error: Module not installed`**
You need to run `terraform init` before `terraform validate`/`plan` — it resolves modules into the local cache.
```powershell
terraform init
```

**`Error: Failed to query available provider packages ... locked provider ... does not match configured version constraint`**
The lock file has a provider version cached that doesn't match the constraint in `providers.tf` (e.g. lock has v6.x, but the constraint requires `~> 5.0`). Fix:
```powershell
terraform init -upgrade
```
If that still fails, relax the version constraint in `providers.tf` (e.g. change it to `~> 6.0`).

**Red squiggly lines in `terraform.tfvars`**
This is usually a spell-checker extension in VS Code, not a Terraform error. Run `terraform validate` to confirm — if it returns "Success", the syntax is fine.

**`terraform plan` errors around subnets/AZs**
If you change the region (e.g. to `eu-north-1`), update the `azs` variable in `terraform.tfvars` to match that region's actual AZ names, otherwise you'll get an invalid AZ error.

---

## Cost Estimate

| Resource | Approx. Cost |
|---|---|
| EKS control plane | ~$0.10/hr (~$73/month) — fixed |
| NAT Gateway | ~$0.045/hr + data processing |
| EC2 nodes (e.g. 2x t3.medium) | pay-as-you-go |

**Remember to destroy the stack after testing:**
```powershell
terraform destroy
```

---

## Production Hardening (next steps)

- [ ] Enable an S3 backend + DynamoDB lock (commented block in `providers.tf`)
- [ ] Set `endpoint_public_access = false` for private-only API access + VPN/bastion
- [ ] Separate node groups per workload (spot vs on-demand)
- [ ] Add Cluster Autoscaler or Karpenter
- [ ] Use IRSA to grant least-privilege IAM to the EBS CSI driver / ALB controller (OIDC provider is already set up)
- [ ] Grant additional IAM users/roles cluster access via the `aws-auth` configmap
- [ ] Automate `terraform plan`/`apply` via CI/CD (GitHub Actions) with remote state

---

## Common Interview Questions This Project Covers

- Managed node group vs self-managed vs Fargate profile — trade-offs
- Role of private subnets + NAT Gateway for worker nodes
- What OIDC/IRSA is and why it's needed
- Difference between the EKS cluster IAM role and the node IAM role
- How `kubectl` authenticates to an EKS cluster (`aws eks get-token`)
- Why use Terraform modules, and how to design a module contract
- How provider version locking (`.terraform.lock.hcl`) works