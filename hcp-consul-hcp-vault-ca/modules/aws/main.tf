resource "aws_security_group" "open" {
  vpc_id = var.aws_vpc_id
  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["216.80.1.157/32"]
  }
  ingress {
    from_port = 8301
    protocol  = "tcp"
    to_port   = 8301
    cidr_blocks = [var.hvn_cidr]
  }
  ingress {
    from_port = 8301
    protocol  = "udp"
    to_port   = 8301
    cidr_blocks = [var.hvn_cidr]
  }
  ingress {
    from_port = 8301
    protocol  = "tcp"
    to_port   = 8301
    self = true
  }
  ingress {
    from_port = 8301
    protocol  = "udp"
    to_port   = 8301
    self = true
  }
  egress {
    from_port = 8300
    protocol  = "tcp"
    to_port   = 8300
    cidr_blocks = [var.hvn_cidr]
  }
  egress {
    from_port = 8301
    protocol  = "tcp"
    to_port   = 8301
    cidr_blocks = [var.hvn_cidr]
  }
  egress {
    from_port = 8301
    protocol  = "udp"
    to_port   = 8301
    cidr_blocks = [var.hvn_cidr]
  }
  egress {
    from_port = 8301
    protocol  = "tcp"
    to_port   = 8301
    self = true
  }
  egress {
    from_port = 8301
    protocol  = "udp"
    to_port   = 8301
    self = true
  }
  egress {
    from_port = 443
    protocol  = "tcp"
    to_port   = 443
    cidr_blocks = [var.hvn_cidr]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



