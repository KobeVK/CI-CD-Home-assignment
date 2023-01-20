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
  subnet_id                   = aws_subnet.Public_Subnet_1.id
  tags                        = var.tag_name
  vpc_id                      = var.vpc_id
  cidr_block                  = var.vpc-cidr
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
}