variable "aws_region" {
    type = string
}

variable "availability_zone_names" {
  type    = list(string)
  default = ["ap-northeast-2a"]
}

variable "vpc_cidr" {
  type = string
}

variable "public_cidr" {
}

variable "private_cidr" {
}