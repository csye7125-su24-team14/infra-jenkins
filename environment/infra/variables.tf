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

variable "docker_hub_password" {
  description = "Docker Hub Password"
  type        = string
}

variable "docker_hub_username" {
  description = "Docker Hub Username"
  type        = string
}

variable "git_hub_username" {
  description = "Git Hub Username"
  type        = string
}

variable "git_hub_password" {
  description = "Git Hub Password"
  type        = string
}


variable "jenkins_admin_user_password" {
  description = "Jenkins admin user password"
  type        = string
}

variable "jenkins_admin_username" {
  description = "Jenkins admin user name"
  type        = string
}