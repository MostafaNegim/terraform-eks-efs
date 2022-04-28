# Overall View

In this Chapter, the directory structures and how each module has been implemented is described.
## 1. VPC
To provision a `VPC`, `private` and `public subnets`, `natgateway` and respective `security groups`, [AWS VPC module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.32.0) has been used. According to [Hashicorp-Provision an EKS Cluster (AWS)](
https://github.com/hashicorp/learn-terraform-provision-eks-cluster), the following `tf` files in the `eks` directory have been implemented:
> 1. `vpc.tf`: create a VPC with a public and private subnet, a natgateway and related options.   
> 2. `sgs.tf` :  provisions the security groups used by the EKS cluster.

## 2. EKS

> 3. `eks-cluster.tf`: provisions all the resources (AutoScaling Groups, etc...) required to set up an EKS cluster using the [AWS EKS Module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/11.0.0). 3 node groups (with the private subnet) - system pod node, cpu-application node and gpu application node with desired capacity=1 has been created. *Taint* is also assigned to the nodes to allow the pods to schedule onto nodes with matching taints.
> 4. `kubernetes.tf`: the Kubernetes provider is included in this file so the EKS module can complete successfully.
## 3. Ingress Controller
To add ingress controller and get a public Network load balancer, [Helm Module](https://registry.terraform.io/providers/hashicorp/helm/latest/docs) and [Kubernetes-ingress-nginx](https://github.com/kubernetes/ingress-nginx) have been used. According to the [AWS](https://aws.amazon.com/blogs/opensource/network-load-balancer-nginx-ingress-controller-eks/) and [Hashicorp](https://learn.hashicorp.com/tutorials/terraform/helm-provider?in=terraform/use-case) documentation, the following `tf` file in the `nginx` directory has been implemented:
> 1. `helm_release.tf`:  official ingress controller from kubernetes repository has been installed using helm module. Please note that this chart will create a Kubernetes service of type:loadbalancer with the Network Load Balancer(NLB) annotations, and this load balancer sits in front of the ingress controller.
> 2. `kubernetes.tf` : using `terraform_remote_state` data block, information of eks cluster has been extracted from `eks` module.

![nlb-nginx](images/nlb-nginx2.png "nlb nginx")
## 4. EFS

# How to run
Statefile