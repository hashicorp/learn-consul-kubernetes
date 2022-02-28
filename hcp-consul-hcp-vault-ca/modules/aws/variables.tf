variable "aws_vpc_id" {
  type = string
  description = "VPC ID passed in to this module"
}

variable "hvn_cidr" {
  type = string
  description = "CIDR for HCP"
}

variable "aws_cidr" {
  type = string
}