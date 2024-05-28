variable "aws_region" {
  description = "aws region name"
  type        = string
}

variable "aws_profile" {
  description = "aws profile name"
  type        = string
}

variable "aws_default_vpc" {
  description = "aws default vpc"
  type        = string
}

variable "aws_default_public_subnet" {
  description = "aws default public subnet"
  type        = string
}

variable "aws_elastic_ip" {
  description = "aws elastic ip"
  type        = string
}


variable "my_ami" {
  description = "my ami"
  type        = string
}

variable "domain_name" {
  description = "Hosted Zone"
  type        = string
}

variable "aws_account_id" {
  description = "Aws Accound ID"
  type        = string
}