variable "aws_region" {
  default = "ap-southeast-2"
}

variable "vpc_cidr_block" {
  description = "Range of IPV4 address for the VPC."
  default = "172.17.0.0/16"
}

variable "az_count" {
  default = "2"
}

variable "aws_ami" {
  default = "ami-0bc49f9283d686bab"
}

variable "aws_instance_type" {
  default = "t2.micro"
}

variable "wpkeypair" {
  default = "wordpress_test"
}