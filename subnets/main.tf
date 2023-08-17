resource "aws_subnet" "main" {
  count = length(var.web_subnet_cidr_block)
  vpc_id     = var.vpc_id
  cidr_block = element(var.subnets, count.index)

  
    tags = merge ({ Name = "${var.env}-${var.subnet_name}-web_subnet"}, var.tags )
  
}