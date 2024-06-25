# data "aws_availability_zones" "available" {
#   state = "available"
# }

# output "availability_zones" {
#   value = data.aws_availability_zones.available.names
# }

# VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "yoMismo"
    Demo = "Terraform"
  }
}

