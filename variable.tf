variable "cidr_block" {}
variable "subnets" {}
variable "tags" {}
variable "env" {}
variable "az" {
  default = ["us-east-1a", "us-east-1b"]
}
variable "default_vpc_id" {}
# variable "route_table_ids" {}