# Terraform settings
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16" # constrain provider version to prevent configuration incompatibilities
    }
  }

  required_version = ">= 1.2.0"
}