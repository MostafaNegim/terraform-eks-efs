#!/bin/bash

# aws eks list-clusters 
# export cluster_name=$(aws eks list-clusters | jq ".clusters[0]")
export cluster_name="omni-eks-lXm4xB5y"
export vpc_id=$(aws eks describe-cluster \
    --name $cluster_name \
    --query "cluster.resourcesVpcConfig.vpcId" \
    --output text)
export cidr_range=$(aws ec2 describe-vpcs \
    --vpc-ids $vpc_id \
    --query "Vpcs[].CidrBlock" \
    --output text)

export security_group_id=$(aws ec2 create-security-group \
    --group-name MyEfsSecurityGroup \
    --description "My EFS security group" \
    --vpc-id $vpc_id \
    --output text)

aws ec2 authorize-security-group-ingress \
    --group-id $security_group_id \
    --protocol tcp \
    --port 2049 \
    --cidr $cidr_range

export file_system_id=$(aws efs create-file-system \
    --performance-mode generalPurpose \
    --query 'FileSystemId' \
    --output text)

aws ec2 describe-subnets \
    --filters "Name=vpc-id,Values=$vpc_id" \
    --query 'Subnets[*].{SubnetId: SubnetId,AvailabilityZone: AvailabilityZone,CidrBlock: CidrBlock}' \
    --output table

aws efs create-mount-target \
    --file-system-id $file_system_id \
    --subnet-id subnet-0f7d353a0be8c98eb \
    --security-groups $security_group_id

# aws eks update-kubeconfig --name $cluster_name

# eksctl delete  iamserviceaccount --namespace kube-system --name efs-csi-controller-sa --cluster $cluster_name

aws efs describe-file-systems --query "FileSystems[*].FileSystemId" --output text