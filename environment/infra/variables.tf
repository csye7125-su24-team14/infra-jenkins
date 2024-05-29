variable "aws_region" {
  description = "aws region name"
  type        = string
}

variable "aws_profile" {
  description = "aws profile name"
  type        = string
}

variable "cidr_name" {
  description = "Name of cidr block"
  type        = string
}
variable "vpc_tag_name" {
  description = "tag Name of Vpc"
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