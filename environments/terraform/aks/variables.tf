variable "location" {
  default     = "West US 2"
  description = "The location to launch this AKS cluster in."
}

variable "subscription_id" {
  default     = ""
  description = "The subscription ID used when creating Azure resources."
}

variable "tenant_id" {
  default     = ""
  description = "The tenant ID used when creating Azure resources."
}

variable "client_id" {
  default     = ""
  description = "The client ID of the service principal to be used by Kubernetes when creating Azure resources like load balancers."
}

variable "client_secret" {
  default     = ""
  description = "The client secret of the service principal to be used by Kubernetes when creating Azure resources like load balancers."
}

variable "cluster_count" {
  default     = 1
  description = "The number of Kubernetes clusters to create."
}

variable "service_principal_password" {
  default = "$up3rS3cr3t"
  description = "The password associated with the service principal account."
}
