variable "cloud_provider" {
  type = string
  description = "Cloud Provider"
  default = "aws"
}

variable "hvn_name" {
  type = string
  description = "Name given to the HVN"
}
variable "hcp_region" {
  type = string
  description = "Region for HCP"
}

variable "cidr_block" {
  type = string
  description = "CIDR block for HVN"
}