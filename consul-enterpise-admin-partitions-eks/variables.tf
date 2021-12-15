variable "author" {}
variable "team" {}
variable "eks_cluster_name" {}
variable "eks_cluster_name_1" {}
variable "eks_cluster_name_2" {}

variable "default_tags" {
  type = map(string)
  default = {
    Team       = "education" #var.deploymentInfo.team
    deployedBy = "webdog"    #var.deploymentInfo.author
  }
}

