output "aws_ec2_public_ip" {
  description = "The public IP address of the EC2 instance."
  value       = aws_instance.gaurav.public_ip
}