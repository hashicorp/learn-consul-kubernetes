variable "name" {
  description = "Name to be used on all the resources as identifier."
  type        = string
  default     = "mesh-gateways-dc2"
}

variable "region" {
  description = "AWS region."
  type        = string
  default     = "us-west-2"
}

variable "default_tags" {
  description = "Default Tags for AWS"
  type        = map(string)
  default = {
    Environment = "dev"
    Team        = "Education-Consul"
    tutorial    = "Mesh Gateways with Consul"
  }
}

variable "output_dir" {
  default = "."
  description = "The directory to store output artifacts like kubeconfig files"
}