variable "cluster_name" {
  type = string
  default = "cloudforge-cluster"
}

variable "cluster_version" {
  type = string
  default = "1.30"
}

variable "subnet_ids" {
  description = "All subnet IDs (private + public) for the EKS control plane ENIs"
  type        = list(string)
}

variable "node_subnet_ids" {
  description = "Private subnet IDs where worker nodes will run"
  type        = list(string)
}

variable "endpoint_public_access" {
  type    = bool
  default = true
}

variable "node_instance_types" {
  type = list(string)
}

variable "node_desired_size" {
  type = number
}

variable "node_min_size" {
  type = number
}

variable "node_max_size" {
  type = number
}

variable "node_capacity_type" {
  type    = string
  default = "ON_DEMAND"
}
