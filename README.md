# terraform-eks-efs

## 1. Terraform 

## VPC
To provision a `VPC`, `private` and `public subnets`, `natgateway` and respective `security groups`, [AWS VPC module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.32.0) has been used. According to [Hashicorp-Provision an EKS Cluster (AWS)](
https://github.com/hashicorp/learn-terraform-provision-eks-cluster), the following `tf` files in the `eks` directory have been implemented:
> 1. `vpc.tf`: create a VPC with a public and private subnet, a natgateway and related options.   
> 2. `sgs.tf` :  provisions the security groups used by the EKS cluster.

## EKS

> 3. `eks-cluster.tf`: provisions all the resources (AutoScaling Groups, etc...) required to set up an EKS cluster using the [AWS EKS Module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/11.0.0). 3 node groups (with the private subnet) - system pod node, cpu-application node and gpu application node with desired capacity=1 has been created. Taint is also assigned to the node to allow the pods to schedule onto nodes with matching taints.
> 4. `kubernetes.tf`: the Kubernetes provider is included in this file so the EKS module can complete successfully.
## Ingress Controller

## EFS


Statefile