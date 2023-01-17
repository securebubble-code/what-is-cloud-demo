# General Variables
#########################################################
# DO NOT CHANGE BELOW VARIABLES  ONCE DEPLOYED!
#########################################################
variable "aws_region" {
  description = "AWS region to deploy resources into"
  default     = "eu-west-1"
}
variable "prefix" {
  description = "Prefix to assign to AWS resources"
  default     = "brighton-cloud-demos"
}
variable "remote_state_bucket_name" {
  description = "Name of S3 bucket to store terraform state"
  default     = "terraform-state-storage"
}
variable "remote_state_dynamodb_lock_name" {
  description = "Name of DyanmoDB table to indicate terraform state lock"
  default     = "terraform-state-lock"
}
variable "remote_state_master_state_file" {
  description = "Name of the top level master state file for resources"
  default     = "base.tfstate"
}

#########################################################
# STORE CHANGEABLE VARIABLES BELOW
#########################################################
