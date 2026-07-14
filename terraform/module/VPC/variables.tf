variable "vpc_cidr" {
  description = "CIDR value for VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_Cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_Cidr" {
  default = "10.0.2.0/24"
}

variable "cidr_blocks" {
  default = ["0.0.0.0/0"]
}