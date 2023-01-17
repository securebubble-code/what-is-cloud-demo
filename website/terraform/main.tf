# Provider to pull account details
locals {
  bucket_name = var.environment != "prod" ? "${var.environment}.${var.website_domain}" : var.website_domain
}

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

provider "aws" {
# Provider for us-east-1 resources
  region = "us-east-1"
  alias  = "us-east-1"
}

# Config of remote state
terraform {
  required_version = "~> 1.3.7"
  backend "s3" {
    encrypt        = true
    bucket         = "brighton-cloud-demos-terraform-state-storage"
    dynamodb_table = "brighton-cloud-demos-terraform-state-lock"
    key            = "brighton-cloud-demos/website.tfstate"
    region         = "eu-west-1"
  }
}
