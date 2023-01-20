provider "aws" {
  region     = var.aws_region
}

resource "aws_security_group" "sg" {
  name        = "sec_group"
  description = "Allow access from service two"
}

#Create a new EC2 launch configuration
resource "aws_instance" "ec2_public" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  security_groups             = aws_security_group.sg.name
  subnet_id                   = var.subnet_id
  tags                        = var.tag_name
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
}