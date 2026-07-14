variable "ami_value" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "The subnet ID for the EC2 instance"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID for the EC2 instance"
  type        = string
}