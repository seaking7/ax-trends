
################################################################################
# Security groups
################################################################################

resource "aws_security_group" "rds" {
  name   = "${var.global_prefix}-rds"
  vpc_id = var.vpc_id
  description = "rds_security_group"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "TCP"
    cidr_blocks = var.private_cidr_blocks
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "TCP"
    cidr_blocks = var.public_cidr_blocks
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sc-tf-${var.global_prefix}-rds"
  }
}

