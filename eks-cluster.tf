module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.20"
  subnets         = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "system-pod"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.system_pod.id]
      asg_desired_capacity          = 1
    },
    {
      name                          = "cpu-application"
      instance_type                 = "t2.medium"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.cpu_application.id]
      asg_desired_capacity          = 1
    },
    {
      name                          = "gpu-application"
      instance_type                 = "t2.medium"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.gpu_application.id]
      asg_desired_capacity          = 1
    },
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}