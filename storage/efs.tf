resource "aws_efs_file_system" "efs" {
  creation_token   = "efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = true
  tags = {
    "Name" = "EFS"
  }
}

resource "aws_efs_mount_target" "efs_mt" {
  count           = length(data.aws_instance.ec2_subnets)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = data.aws_instance.ec2_subnets[count.index].subnet_id
  security_groups = ["${aws_security_group.ingress_efs.id}"]
}



# data "aws_availability_zones" "available" {}

data "aws_subnets" "vpc_subnets" {
    # vpc_id = 
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks_vpc.id]
  }
}

data "aws_instances" "ec2s" {
  filter {
    name   = "tag:kubernetes.io/cluster/${data.aws_eks_cluster.cluster.name}"
    values = ["owned"]
  }
}

data "aws_instance" "ec2_subnets" {
  # for_each    = toset(data.aws_instances.ec2s.ids)
  count    = length(data.aws_instances.ec2s.ids)
  instance_id = data.aws_instances.ec2s.ids[count.index]
}

# data "aws_ec2_instance_types" "test" {
#   filter {
#     name   = "tag:kubernetes.io/cluster/${data.aws_eks_cluster.cluster.name}"
#     values = ["owned"]
#   }
# }
