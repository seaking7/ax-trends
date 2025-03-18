# This variable defines the AWS Region.
variable "aws_region" {
  description = "region to use for AWS resources"
  type        = string
}

variable "global_prefix" {
  type    = string
}

# variable "cidr_blocks_bastion_host" {
#   type = list(string)
#   default = ["10.0.4.0/24"]
# }

variable "vpc_id" {
}


variable "subnet_ids" {
}


variable "public_cidr_blocks" {
  type = list(string)
}

variable "private_cidr_blocks" {
  type = list(string)
}

