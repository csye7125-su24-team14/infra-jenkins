terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}


module "jenkins_app" {
  source                      = "../../jenkins-module"
  aws_region                  = var.aws_region
  my_ami                      = var.my_ami
  domain_name                 = var.domain_name
  aws_account_id              = var.aws_account_id
  vpc_tag_name                = var.vpc_tag_name
  cidr_name                   = var.cidr_name
  aws_elastic_ip              = var.aws_elastic_ip
  docker_hub_username         = var.docker_hub_username
  docker_hub_password         = var.docker_hub_password
  jenkins_admin_user_password = var.jenkins_admin_user_password
  jenkins_admin_username      = var.jenkins_admin_username
  git_hub_username            = var.git_hub_username
  git_hub_password            = var.git_hub_password
}
