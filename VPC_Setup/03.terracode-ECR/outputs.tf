output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.netflix_ecr_repo.repository_url
}

output "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.netflix_ecr_repo.arn
}

output "ecr_repository_name" {
  description = "Name of the ECR repository"
  value       = aws_ecr_repository.netflix_ecr_repo.name
}

output "ecr_registry_id" {
  description = "Registry ID of the ECR repository"
  value       = aws_ecr_repository.netflix_ecr_repo.registry_id
}
