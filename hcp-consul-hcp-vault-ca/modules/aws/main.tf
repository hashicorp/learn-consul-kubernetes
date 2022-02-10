resource "aws_security_group" "open" {
  vpc_id = var.aws_vpc_id
  ingress {
    from_port = 0
    protocol  = "ALL"
    to_port   = 65535
  }
  egress {
    from_port = 0
    protocol  = "ALL"
    to_port   = 65535
  }
}



