terraform {
  required_version = ">= 1.0"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.12.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "my-terraform-remotestate"
    key            = "terraform.tfstate"
    dynamodb_table = "terraform-state-lock-dynamo"
    region         = "ap-southeast-2"
  }
}

provider "aws" {
  alias   = "ap-southeast-2"
  region  = "ap-southeast-2"
  profile = "default"
}