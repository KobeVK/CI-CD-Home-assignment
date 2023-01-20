#paramatized
variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "eu-west-3"
}

variable "key_name" {
  description = " SSH keys to connect to ec2 instance"
  default     = "mac_23"
}

variable "instance_type" {
  description = "instance type for ec2"
  default     = "t2.micro"
}

variable "security_group" {
  description = "Name of security group"
  default     = "launch-wizard-1"
}

#paramatized
variable "tag_name" {
  description = "Tag Name of for Ec2 instance"
  default     = "my-Terraform_ec2-instance"
}

variable "ami_id" {
  description = "AMI for Ubuntu Ec2 instance"
  default     = "ami-0a89a7563fc68be84"
}

variable "vpc-cidr" {
  default     = "172.31.0.0/16"
  description = "VPC CIDR BLOCK"
  type        = string
}

variable "Public_Subnet_1" {
  default     = "172.31.0.0/20"
  description = "Public_Subnet_1"
  type        = string
}

variable "vpc_id" {
  default     = "vpc-72e11d1a"
  description = "vpc_id"
  type        = string
}