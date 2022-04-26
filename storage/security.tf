resource "aws_security_group" "ingress_efs" {
   name = "ingress-efs-sg"
   vpc_id = data.aws_vpc.eks_vpc.id

   // NFS
   ingress {
    #  security_groups = ["${aws_security_group.ingress-test-env.id}"]
     from_port = 2049
     to_port = 2049
     protocol = "tcp"
     cidr_blocks      = [data.aws_vpc.eks_vpc.cidr_block]
   }
   tags = {
     "Name" = "ingress-efs-sg"
   }
 }

data "aws_vpc" "eks_vpc" {
  filter {
    name   = "tag:Name"
    values = ["omni-vpc"]
  }
}