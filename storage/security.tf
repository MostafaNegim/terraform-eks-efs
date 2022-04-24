# resource "aws_security_group" "ingress-efs-test" {
#    name = "ingress-efs-test-sg"
#    vpc_id = "${aws_vpc.test-env.id}"

#    // NFS
#    ingress {
#      security_groups = ["${aws_security_group.ingress-test-env.id}"]
#      from_port = 2049
#      to_port = 2049
#      protocol = "tcp"
#    }

#    // Terraform removes the default rule
#    egress {
#      security_groups = ["${aws_security_group.ingress-test-env.id}"]
#      from_port = 0
#      to_port = 0
#      protocol = "-1"
#    }
#  }