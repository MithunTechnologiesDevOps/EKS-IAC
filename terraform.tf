terraform {
  required_version = "~>1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }

 backend "s3" {
    bucket = "terraform-remote-state-mithuntech-demo-s3"
    region = "ap-south-1"
    dynamodb_table = "terraform-state-locking"
  }

}