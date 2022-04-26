resource "aws_iam_policy" "efs" {
  name = "AmazonEKS-EFS-CSI-Driver-Policy"
  description = ""
  policy = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "elasticfilesystem:DescribeAccessPoints",
          "elasticfilesystem:DescribeFileSystems"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "elasticfilesystem:CreateAccessPoint"
        ],
        "Resource": "*",
        "Condition": {
          "StringLike": {
            "aws:RequestTag/efs.csi.aws.com/cluster": "true"
          }
        }
      },
      {
        "Effect": "Allow",
        "Action": "elasticfilesystem:DeleteAccessPoint",
        "Resource": "*",
        "Condition": {
          "StringEquals": {
            "aws:ResourceTag/efs.csi.aws.com/cluster": "true"
          }
        }
      }
    ]
  })
  
  provisioner "local-exec" {
    command ="eksctl utils associate-iam-oidc-provider --cluster ${data.aws_eks_cluster.cluster.name} --approve"
  }
  provisioner "local-exec" {
    command ="eksctl create iamserviceaccount --cluster ${data.aws_eks_cluster.cluster.name} --namespace kube-system --name efs-csi-controller-sa --attach-policy-arn ${self.arn} --approve"   
  }
} 