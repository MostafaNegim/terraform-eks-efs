resource "null_resource" "storageclass-config" {
    provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${data.aws_eks_cluster.cluster.name}"
    }
  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.storageclass.rendered}\nEOF"
  }
#   triggers = {
#     build_number = data.external.cloudwatch-config.result.sha1
#   }
#   depends_on = [kubernetes_namespace.cloudwatch]
}

resource "null_resource" "gp2_non_default" {
  provisioner "local-exec" {
    command = "kubectl patch storageclass gp2 -p '{\"metadata\": {\"annotations\":{\"storageclass.kubernetes.io/is-default-class\":\"false\"}}}'"
  }
}

data "template_file" "storageclass" {
  template = "${file("${path.module}/manifests/storageclass.yaml")}"
  vars = {
    fileSystemId = "${aws_efs_file_system.efs.id}"
  }
}