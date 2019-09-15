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