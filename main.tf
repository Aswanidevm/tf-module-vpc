resource "aws_vpc" "main" {
  enable_dns_support = true
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

 
    tags = merge ({ Name = "${var.env}-vpc"}, var.tags )
 
}


module "subnets" {
  source = "./subnets"
  
  for_each = var.subnets
  subnet_name = each.key
  cidr_block = each.value["cidr_block"]
  env = var.env
  tags = var.tags
  vpc_id = aws_vpc.main.id
  az = var.az

}

# module "single_account_single_region" {
#   source = "./subnets"

#   providers = {
#     aws.this = aws
#     aws.peer = aws
#   }

#   this_vpc_id = aws_vpc.main.id
#   peer_vpc_id = var.default_vpc_id

#   auto_accept_peering = true

#   tags = {
#     Name        = "tf-single-account-single-region"
#     Environment = "Test"
#   }
# }
resource "aws_vpc_peering_connection" "peering" {
  
  peer_vpc_id   = var.default_vpc_id
  vpc_id        = aws_vpc.main.id
  auto_accept   = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge ({ Name = "${var.env}-igw"}, var.tags )
}

resource "aws_route" "route-igw" {
  route_table_id            = lookup(lookup(module.subnets, "public", null), "route_table_ids", null)
  # module.subnets["public"].route_table_ids
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id  = aws_internet_gateway.igw.id
  
}

resource "aws_eip" "ngw" {
  vpc      = true
}

resource "aws_nat_gateway" "examplngwe" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = lookup(lookup(module.subnets, "public", null), "subnet_ids", null[0])

 tags = merge ({ Name = "${var.env}-ngw"}, var.tags )
  
}