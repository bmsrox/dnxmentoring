provider "aws" {
  profile = "default"
  region  = "ap-southeast-2"
  version = "~> 2.67"
}

terraform {
  backend "s3" {
    bucket = "wordpress-tfstates-terraform"
    key = "terraformt.tfstate"
    region = "ap-southeast-2"
  }
}