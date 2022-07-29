
resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "${var.aws_prefix}-${local.cluster_name}-worker_group_mgmt_one"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
  ingress {
    description = "Consul RPC TCP"
    protocol    = "tcp"
    from_port   = 8300
    to_port     = 8300
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Consul Serf TCP"
    protocol    = "tcp"
    from_port   = 8301
    to_port     = 8302
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Consul Serf UDP"
    protocol    = "udp"
    from_port   = 8301
    to_port     = 8302
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Consul Serf Server TCP"
    protocol    = "tcp"
    from_port   = 9301
    to_port     = 9302
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Consul Serf Server UDP"
    protocol    = "udp"
    from_port   = 9301
    to_port     = 9302
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Consul API TCP"
    protocol    = "tcp"
    from_port   = 8500
    to_port     = 8502
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Consul DNS TCP"
    protocol    = "tcp"
    from_port   = 8600
    to_port     = 8600
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Consul DNS UDP"
    protocol    = "udp"
    from_port   = 8600
    to_port     = 8600
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Consul Sidecars"
    protocol    = "tcp"
    from_port   = 21000
    to_port     = 21255
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    self = true
  }

  tags = {
    Owner = var.owner
  }
}

resource "aws_security_group" "worker_group_mgmt_two" {
  name_prefix = "${var.aws_prefix}-${local.cluster_name}-worker_group_mgmt_two"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "192.168.0.0/16",
    ]
  }
  ingress {
    description = "Consul RPC TCP"
    protocol    = "tcp"
    from_port   = 8300
    to_port     = 8300
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Consul Serf TCP"
    protocol    = "tcp"
    from_port   = 8301
    to_port     = 8302
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Consul Serf UDP"
    protocol    = "udp"
    from_port   = 8301
    to_port     = 8302
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Consul Serf Server TCP"
    protocol    = "tcp"
    from_port   = 9301
    to_port     = 9302
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Consul Serf Server UDP"
    protocol    = "udp"
    from_port   = 9301
    to_port     = 9302
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Consul API TCP"
    protocol    = "tcp"
    from_port   = 8500
    to_port     = 8502
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Consul DNS TCP"
    protocol    = "tcp"
    from_port   = 8600
    to_port     = 8600
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Consul DNS UDP"
    protocol    = "udp"
    from_port   = 8600
    to_port     = 8600
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Consul Sidecars"
    protocol    = "tcp"
    from_port   = 21000
    to_port     = 21255
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    self = true
  }

  tags = {
    Owner = var.owner
  }

}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "${var.aws_prefix}-${local.cluster_name}-all_worker_management"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
  tags = {
    Owner = var.owner
  }
}