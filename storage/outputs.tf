output "available" {
  value = data.aws_availability_zones.available
}
output "subnets" {
  value = data.aws_subnets.sns
}