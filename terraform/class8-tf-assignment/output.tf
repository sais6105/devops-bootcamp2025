# output.tf
output "ec2_public_ip" {
  description = "public ip for ec2"
  value       = aws_instance.public.public_ip
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "private_subnet1_id" {
  description = "The IDs of the private subnet1"
  value       = aws_subnet.private_subnet1.id
}

# output "private_subnet2_id" {
#   description = "The IDs of the private subnet2"
#   value       = aws_subnet.private_subnet2.id
# }

output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.postgres.endpoint
}

output "public_ec2_instance_id" {
  description = "The ID of the public EC2 instance"
  value       = aws_instance.public.id
}

output "private_ec2_instance_id" {
  description = "The ID of the private EC2 instance"
  value       = aws_instance.private.id
}