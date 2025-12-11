output "vpc_id" {
  value = aws_vpc.main.id
}

output "eks_cluster_name" {
  value = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "app_role_arn" {
  value = aws_iam_role.app_role.arn
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.todos.name
}
