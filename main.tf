variable "aws_region" {
    default = "eu-west-3"
}

provider "aws" {
  region     = var.aws_region
}

resource "aws_instance" "example" {
  ami           = "ami-0a89a7563fc68be84"
  instance_type = "t2.micro"
  key_name      = "mac_23"
  vpc_security_group_ids =  ["sg-0fdca7d4d5179465b"]
}