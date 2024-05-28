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
  source = "../../jenkins-module"
  aws_region        = var.aws_region
  my_ami            = var.my_ami
  domain_name       = var.domain_name
  aws_account_id    = var.aws_account_id
  aws_default_public_subnet = var.aws_default_public_subnet
  aws_default_vpc = var.aws_default_vpc
  aws_elastic_ip = var.aws_elastic_ip
}