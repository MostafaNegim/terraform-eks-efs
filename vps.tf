variable "region" {
  default = "us-east-1"
  description = "AWS region"
}
provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

resource "aws_security_group" "test" {
  name = "Hamid-request"
  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "ssh"
    from_port        = 22
    protocol         = "tcp"
    security_groups  = null
    self             = false
    to_port          = 22
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    },
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "web"
      from_port        = 80
      protocol         = "tcp"
      security_groups  = null
      self             = false
      to_port          = 80
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
  }]
}