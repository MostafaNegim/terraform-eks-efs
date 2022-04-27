# output "ec2s" {
#   value = data.aws_instances.ec2s
# }
# output "subnets" {
#   value = data.aws_subnets.sns
# }

# output "vpc" {
#   value = data.aws_vpc.eks_vpc
# }

# output "eks" {
#   value = data.aws_eks_cluster.cluster
# }

output "ec2_subnets" {
  value = data.aws_instance.ec2_subnets
}
