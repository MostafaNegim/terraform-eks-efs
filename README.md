# Overall View

In this Chapter, the directory structures and how each module has been implemented is described.
## 1. VPC
To provision a `VPC`, `private` and `public subnets`, `natgateway` and respective `security groups`, [AWS VPC module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.32.0) has been used. According to [Hashicorp-Provision an EKS Cluster (AWS)](
https://github.com/hashicorp/learn-terraform-provision-eks-cluster), the following `tf` files in the `eks` directory have been implemented:
>  `vpc.tf`: create a VPC with a public and private subnet, a natgateway and related options.   
> * `sgs.tf` :  provisions the security groups used by the EKS cluster.

## 2. EKS

> * `eks-cluster.tf`: provisions all the resources (AutoScaling Groups, etc...) required to set up an EKS cluster using the [AWS EKS Module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/11.0.0). 3 node groups (with the private subnet) - system pod node, cpu-application node and gpu application node with desired capacity=1 has been created. *Taint* is also assigned to the nodes to allow the pods to schedule onto nodes with matching taints.
> * `kubernetes.tf`: the Kubernetes provider is included in this file so the EKS module can complete successfully.
## 3. Ingress Controller
To add ingress controller and get a public Network load balancer, [Helm Module](https://registry.terraform.io/providers/hashicorp/helm/latest/docs) and [Kubernetes-ingress-nginx](https://github.com/kubernetes/ingress-nginx) have been used. According to the [AWS](https://aws.amazon.com/blogs/opensource/network-load-balancer-nginx-ingress-controller-eks/) and [Hashicorp](https://learn.hashicorp.com/tutorials/terraform/helm-provider?in=terraform/use-case) documentation, the following `tf` files in the `nginx` directory have been implemented:
> * `helm_release.tf`:  official ingress controller from kubernetes repository has been installed using helm module. Please note that this chart will create a Kubernetes service of type:loadbalancer with the Network Load Balancer(NLB) annotations, and this load balancer sits in front of the ingress controller.
> * `kubernetes.tf` : using `terraform_remote_state` data block, information of eks cluster has been extracted from `eks` module.

<p align="center" >
  <img  width="40%" src="images/nlb-nginx2.png" />
</p>

## 4. EFS
To create an encrypted EFS and attach it to the EKS cluster with its storage class as default storage class, according to the [AWS](https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html), the following `tf` files in the `storage` directory have been implemented:
> * `iam.tf`: Create an IAM policy and assign it to an IAM role. The policy will allow the Amazon EFS driver to interact with the file system. Then, it runs an `local-exec` provisioner to create AWS Identity and Access Management (IAM) OpenID Connect (OIDC) provider for the cluster. It is assumed that `eksctl` has been installed on the machine running this script. After that, it creates the IAM role and Kubernetes service account. It also attaches the policy to the role, annotates the Kubernetes service account with the IAM role ARN, and adds the Kubernetes service account name to the trust policy for the IAM role.
> * `efs_csi_helm.tf`: installs the Amazon EFS CSI driver using Helm.
> * `security.tf`: creates a security group with an inbound rule that allows inbound NFS traffic for the Amazon EFS mount points.
> * `efs.tf`: creates an encrypted Amazon EFS file system for the Amazon EKS cluster and creates mount targets.
> * `storage.tf`: Deploy `StorageClass` manifest for Amazon EFS and make it default.

### Deploy a sample application

# How to run
Follow these steps to run these scripts, please. It is assumed that, `kubectl`, `eksctl` and `aws cli` have been installed on the machine running these scripts.
1. *Install vpc and eks cluster* : 
    1. `cd eks`
    1. `terraform init`
    1. `terraform apply` and press `y` or `terraform apply --auto-approve`
1. *Install ingress controller* : 
    1. `cd nginx`
    1. `terraform init`
    1. `terraform apply` and press `y` or `terraform apply --auto-approve`
1. *Install efs storage for the cluster* : 
    1. `cd storage`
    1. `terraform init`
    1. `terraform apply` and press `y` or `terraform apply --auto-approve`


 
# Notes
1. local backend is used for these scripts for the sake of simplicity. A s3 backend with the dynamoDB is better solution for the production use.