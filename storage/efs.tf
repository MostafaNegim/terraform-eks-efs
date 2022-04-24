resource "aws_efs_file_system" "efs" {
  creation_token   = "efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = true
  tags = {
    "Name" = "EFS"
  }
}

resource "aws_efs_mount_target" "efs_mt" {
  count           = length(data.aws_availability_zones.available.names)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = data.aws_subnets.sns.ids[count.index]
#   security_groups = [aws_security_group.efs.id]
}

data "aws_availability_zones" "available" {}
data "aws_subnets" "sns" {
  filter {
    name   = "vpc-id"
    values = ["vpc-0307d6b94597a6c2c"]
  }
}
