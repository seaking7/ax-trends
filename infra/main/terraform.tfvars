aws_region = "ap-northeast-2"
vpc_cidr   = "10.0.0.0/16"
public_cidr_blocks = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]
private_cidr_blocks = ["10.0.64.0/24", "10.0.65.0/24"]
eks-cluster-name    = "test-eks-cluster"