# The identity of the AWS User running this terraform project
data "aws_caller_identity" "current" {}

data "aws_availability_zones" "current" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}