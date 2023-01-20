provider "aws" {
  region     = var.aws_region
  secret_key = ""
  access_key = ""
}

#Create a new EC2 launch configuration
resource "aws_instance" "ec2_public" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  security_groups             = var.security_group
  subnet_id                   = var.subnet_id
  tags                        = var.tag_name
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
}