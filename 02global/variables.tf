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

#########################################################
# STORE CHANGEABLE VARIABLES BELOW
#########################################################

variable "emails" { default = ["antony@securebubble.co.uk"] }
