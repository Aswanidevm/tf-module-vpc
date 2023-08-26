resource "aws_subnet" "main" {
  count = length(var.cidr_block)
  vpc_id     = var.vpc_id
  cidr_block = element(var.cidr_block, count.index)
  availability_zone = element(var.az, count.index)

  
    tags = merge ({ Name = "${var.env}-${var.subnet_name}-web_subnet"}, var.tags )
  
}

resource "aws_route_table" "table" {
  vpc_id = aws_vpc.example.id

  # route {
  #   cidr_block = "10.0.1.0/24"
  #   gateway_id = aws_internet_gateway.example.id
  # }

  # route {
  #   ipv6_cidr_block        = "::/0"
  #   egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
  # }

  tags = merge ({ Name = "${var.env}-${var.subnet_name}-web_subnet"}, var.tags )
}