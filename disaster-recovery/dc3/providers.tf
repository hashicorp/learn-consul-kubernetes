terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.4.1"
    }
  }
  required_version = ">= 1.1.1"
}

provider "aws" {
  region  = var.region
}