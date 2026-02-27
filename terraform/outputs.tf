output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "rds_endpoint" {
  value = module.rds.db_instance_endpoint
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "codedeploy_app_name" {
  value = module.codedeploy.app_name
}

output "codedeploy_deployment_group" {
  value = module.codedeploy.deployment_group_name
}