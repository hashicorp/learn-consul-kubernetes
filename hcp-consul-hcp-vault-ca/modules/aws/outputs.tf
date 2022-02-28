output "aws_security_group_id" {
  value = aws_security_group.open.id
}

output "aws_hashicups_sg" {
  value = aws_security_group.hashicups_kubernetes.id
}