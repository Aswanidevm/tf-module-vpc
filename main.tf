resource "aws_vpc" "main" {
  enable_dns_support = true
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

 
    tags = merge ({ Name = "${var.env}-vpc"}, var.tags )
 
}


module "subnets"{
  source = "./subnets"
  for_each = var.subnets
  subnet_name = each.key
  cidr_block = each.value["cidr_block"]
  env = var.env
  tags = var.tags
  vpc_id = aws_vpc.main.id

}