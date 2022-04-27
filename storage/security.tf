resource "aws_security_group" "ingress_efs" {
  name   = "ingress-efs-sg"
  vpc_id = data.aws_vpc.eks_vpc.id

  // NFS
  ingress {
    #  security_groups = ["${aws_security_group.ingress-test-env.id}"]
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.eks_vpc.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "ingress-efs-sg"
  }
}

data "aws_vpc" "eks_vpc" {
  filter {
    name   = "tag:Name"
    values = [data.terraform_remote_state.eks.outputs.vpc_name]
  }
}