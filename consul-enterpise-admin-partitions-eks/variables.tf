variable "eks_cluster_name_1" {
  type = string
}
variable "eks_cluster_name_2" {
  type = string
}
variable "license_name" {
  type        = string
  description = "The name of the Consul Enterprise license file"
  default     = "consul.hclic"
}

variable "default_tags" {
  type = map(string)
  default = {
    Team       = "education"
    deployedBy = "webdog"
    TTL        = "unlimited"
  }
}

