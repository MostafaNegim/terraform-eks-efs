module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.21"
  subnets         = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  node_groups = {
    sys_pod = {
      name             = "system_pod"
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1

      instance_type = "t2.small"
    }
    cpu_app = {
      name             = "cpu_application"
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1
      # taints = [{
      #     key    = "node-type"
      #     value  = "cpu"
      #     effect = "NO_SCHEDULE"
      #     }
      # ]
      instance_type = "t2.small"
    }
    gpu_app = {
      name             = "gpu_application"
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1
      # taints = [{
      #     key    = "node-type"
      #     value  = "gpu"
      #     effect = "NO_SCHEDULE"
      #     }
      # ]
      instance_type = "t2.small"
    }

  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}