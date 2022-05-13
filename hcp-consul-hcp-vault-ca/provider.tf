terraform {
  required_version = ">= 1.1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.22.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "hcp" {}

