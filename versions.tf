terraform {
  required_version = ">= 1.6.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.59.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.6.0"
    }
  }
}
