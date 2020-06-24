provider "aws" {
  profile = "default"
  region  = "ap-southeast-2"
}

terraform {
  backend "s3" {
    bucket = "wordpress-tfstates-terraform"
    key = "terraformt.tfstate"
    region = "ap-southeast-2"
  }
}