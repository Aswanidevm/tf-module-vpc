resource "aws_vpc" "main" {
  enable_dns_support = true
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}