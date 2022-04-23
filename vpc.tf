variable "region" {
  default = "us-east-1"
  description = "AWS region"
}
provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

