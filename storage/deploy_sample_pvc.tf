resource "null_resource" "sample_pod" {

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/manifests/pod.yaml"
  }
#   triggers = {
#     build_number = data.external.cloudwatch-config.result.sha1
#   }
  depends_on = [null_resource.storageclass-config]
}