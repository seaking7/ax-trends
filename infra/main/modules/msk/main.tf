################################################################################
# Cluster
################################################################################
resource "aws_kms_key" "kafka_kms_key" {
  description = "Key for Apache Kafka"
}

resource "aws_cloudwatch_log_group" "kafka_log_group" {
  name = "kafka_broker_logs"
}

resource "aws_msk_configuration" "kafka_config" {
  kafka_versions    = ["3.4.0"]
  name              = "${var.global_prefix}-config"
  server_properties = <<EOF
auto.create.topics.enable = true
delete.topic.enable = true
EOF
}

resource "aws_msk_cluster" "kafka" {
  cluster_name           = var.global_prefix
  kafka_version          = "3.4.0"
  number_of_broker_nodes = length(data.aws_availability_zones.available.names)
  broker_node_group_info {
    instance_type = "kafka.t3.small" # default value  kafka.m5.large
    storage_info {
      ebs_storage_info {
        volume_size = 100  # default 1000
      }
    }
    client_subnets = [var.subnet_ids[0], var.subnet_ids[1]]
    security_groups = [aws_security_group.kafka.id]
  }
  encryption_info {
    encryption_in_transit {
      client_broker = "PLAINTEXT"
    }
    encryption_at_rest_kms_key_arn = aws_kms_key.kafka_kms_key.arn
  }
  configuration_info {
    arn      = aws_msk_configuration.kafka_config.arn
    revision = aws_msk_configuration.kafka_config.latest_revision
  }
  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = true
      }
      node_exporter {
        enabled_in_broker = true
      }
    }
  }
  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.kafka_log_group.name
      }
    }
  }
}


# resource "tls_private_key" "private_key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "private_key" {
#   key_name   = var.global_prefix
#   public_key = tls_private_key.private_key.public_key_openssh
# }

# resource "local_file" "private_key" {
#   content  = tls_private_key.private_key.private_key_pem
#   filename = "cert.pem"
# }

# resource "null_resource" "private_key_permissions" {
#   depends_on = [local_file.private_key]
#   provisioner "local-exec" {
#     command     = "chmod 600 cert.pem"
#     interpreter = ["bash", "-c"]
#     on_failure  = continue
#   }
# }

################################################################################
# Client Machine (EC2)
################################################################################

# resource "aws_instance" "bastion_host" {
#   depends_on             = [aws_msk_cluster.kafka]
#   ami                    = data.aws_ami.amazon_linux_2023.id
#   instance_type          = "t2.micro"
#   key_name               = aws_key_pair.private_key.key_name
#   subnet_id              = aws_subnet.bastion_host_subnet.id
#   vpc_security_group_ids = [aws_security_group.bastion_host.id]
#   user_data = templatefile("bastion.tftpl", {
#     bootstrap_server_1 = split(",", aws_msk_cluster.kafka.bootstrap_brokers)[0]
#     bootstrap_server_2 = split(",", aws_msk_cluster.kafka.bootstrap_brokers)[1]
#     bootstrap_server_3 = split(",", aws_msk_cluster.kafka.bootstrap_brokers)[2]
#   })
#   root_block_device {
#     volume_type = "gp2"
#     volume_size = 100
#   }
# }
