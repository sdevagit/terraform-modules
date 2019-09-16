provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

module "iam_setup" {
  source = "../modules/IAM"
  name = "deva-app"
  userlist =  ["devakumar.subramani","shyam.devakumar","charmi.devakumar"]
  grouplist = ["admins","users"]
  groupmembership = { "admins" = ["devakumar.subramani"]
    "users"   = ["shyam.devakumar","charmi.devakumar"]
  }
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source                         = "../modules/VPC"
  region                         = "eu-west-1"
  name                           = "myprod"
  tag_live                       = "no"
  vpc_cidr                       = "10.7.150.128/25"
  subnet_public-a_cidr           = "10.7.150.128/28"
  subnet_public-b_cidr           = "10.7.150.144/28"
  subnet_public-c_cidr           = "10.7.150.160/28"
  subnet_private-a_cidr          = "10.7.150.176/28"
  subnet_private-b_cidr          = "10.7.150.192/27"
  subnet_private-c_cidr          = "10.7.150.224/27"
  vgw_network_id                 = "myapp-prod"
}