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

variable "environment" {
  description = "The environment for this deployment - should be provided as part of the Terraform command"
}

#########################################################
# STORE CHANGEABLE VARIABLES BELOW
#########################################################

variable "emails" {
  description = "The email addresses to send notifications to"
  default     = ["antony@securebubble.co.uk"]
}

variable "website_domain" {
  description = "The domain name to associate with the website"
  default     = "brightoncloud-demo.securebubble.xyz"
}

variable "tags" {
  type    = map(string)
  default = {}
}