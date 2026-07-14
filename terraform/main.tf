module "vpc" {
  source = "./module/VPC"
}

module "ec2" {
  source = "./module/EC2"

  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.vpc.security_group_id
}