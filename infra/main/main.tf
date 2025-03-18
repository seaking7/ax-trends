
## VPC, subnet, igw, nat, routing table
module "tf_vpc" {
  source       = "./modules/vpc"
  aws_region   = var.aws_region
  vpc_cidr     = var.vpc_cidr
  public_cidr  = var.public_cidr_blocks
  private_cidr = var.private_cidr_blocks

}

## EKS, EKS NODE
module "tf_eks" {
  source           = "./modules/eks"
  aws_region       = var.aws_region
  eks-cluster-name = var.eks-cluster-name
  vpc_id           = module.tf_vpc.vpc_id
  subnet_ids       = module.tf_vpc.public_subnet_ids
}

## aws eks update-kubeconfig --region ap-northeast-2 --name test-eks-cluster

## MSK
# module "tf_msk" {
#   source              = "./modules/msk"
#   aws_region          = var.aws_region
#   global_prefix       = var.global_prefix
#   vpc_id              = module.tf_vpc.vpc_id
#   subnet_ids          = module.tf_vpc.public_subnet_ids
#   public_cidr_blocks  = var.public_cidr_blocks
#   private_cidr_blocks = var.private_cidr_blocks
# }

## ElastiCache
# module "tf_redis" {
#   source              = "./modules/redis"
#   aws_region          = var.aws_region
#   global_prefix       = var.global_prefix
#   vpc_id              = module.tf_vpc.vpc_id
#   subnet_ids          = module.tf_vpc.public_subnet_ids
#   public_cidr_blocks  = var.public_cidr_blocks
#   private_cidr_blocks = var.private_cidr_blocks
# }