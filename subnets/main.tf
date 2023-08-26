resource "aws_subnet" "main" {
  count = length(var.cidr_block)
  vpc_id     = var.vpc_id
  cidr_block = element(var.cidr_block, count.index)
  availability_zone = element(var.az, count.index)

  
    tags = merge ({ Name = "${var.env}-${var.subnet_name}-web_subnet"}, var.tags )
  
}

resource "aws_route_table" "table" {
  vpc_id = var.vpc_id

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

resource "aws_route_table_association" "association" {
  count = length(aws_subnet.main.*.id)
  subnet_id      = element(aws_subnet.main.*.id, count.index)
  route_table_id = aws_route_table.table.id
}