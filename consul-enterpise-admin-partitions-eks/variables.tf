variable "author" {
  type = string
}
variable "team" {
  type = string
}
variable "eks_cluster_name" {
  type = string
}
variable "eks_cluster_name_1" {
  type = string
}
variable "eks_cluster_name_2" {
  type = string
}
variable "license_file_path" {
  type        = string
  description = "The path to the license file"
  default     = "./consul.hclic"
}

variable "default_tags" {
  type = map(string)
  default = {
    Team       = "education" #var.deploymentInfo.team
    deployedBy = "webdog"    #var.deploymentInfo.author
  }
}

