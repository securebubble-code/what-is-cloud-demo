# Provider to pull account details
provider "aws" {
  region = var.aws_region
  alias  = "identity"
}

data "aws_caller_identity" "current" {
  provider = aws.identity
}

provider "aws" {
  region = var.aws_region
}

# Config of remote state
terraform {
  required_version = "~> 1.3.7"
  backend "s3" {
    encrypt        = true
    bucket         = "brighton-cloud-demos-terraform-state-storage"
    dynamodb_table = "brighton-cloud-demos-terraform-state-lock"
    key            = "brighton-cloud-demos/global.tfstate"
    region         = "eu-west-1"
  }
}
