terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.23.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.3"
    }
  }
}
