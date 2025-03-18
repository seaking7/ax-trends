# This variable defines the AWS Region.
variable "aws_region" {
  description = "region to use for AWS resources"
  type        = string
}

variable "global_prefix" {
  type    = string
}

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

