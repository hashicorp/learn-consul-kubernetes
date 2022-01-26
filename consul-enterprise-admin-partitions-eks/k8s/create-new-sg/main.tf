variable "vpc_id" {}
variable "existing_sg_id" {}
variable "cidr_blocks" {}

data "aws_security_group" "eks_default" {
  id = var.existing_sg_id
}

resource "aws_security_group_rule" "specific-cidrs-ingress" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = data.aws_security_group.eks_default.id
  to_port           = 0
  type              = "ingress"
  # This is a list
  cidr_blocks = var.cidr_blocks
}
resource "aws_security_group_rule" "specific-cidrs-egress" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = data.aws_security_group.eks_default.id
  to_port           = 0
  type              = "egress"
  # This is a list
  cidr_blocks = var.cidr_blocks
}