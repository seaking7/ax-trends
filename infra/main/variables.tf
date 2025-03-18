

variable "aws_region" {
  type    = string
  default = "ap-northeast-2"
}

variable "vpc_cidr" {
  type = string
  # default = "10.0.0.0/16"
}

variable "public_cidr_blocks" {
  type = list(string)
  # default = [
  #   "10.0.1.0/24", 
  #   "10.0.2.0/24"
  #   ]
}

variable "private_cidr_blocks" {
  # default = ["10.0.64.0/24","10.0.65.0/24"]
}

### eks variables
variable "eks-cluster-name" {
  # default = "test-eks-cluster"
  type = string
}


variable "global_prefix" {
  type    = string
  default = "ssp"
}