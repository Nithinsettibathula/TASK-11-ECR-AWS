terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ==========================================
# 1. NETWORKING (VPC, Subnets, IGW)
# ==========================================
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "${var.project_name}-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.project_name}-igw" }
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# ==========================================
# 2. SECURITY GROUPS
# ==========================================
# ALB and ECS Security Group
resource "aws_security_group" "alb_ecs_sg" {
  name        = "${var.project_name}-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Database Security Group (Inbound from ECS only)
resource "aws_security_group" "db_sg" {
  name   = "${var.project_name}-db-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_ecs_sg.id]
  }
}

# ==========================================
# 3. LOAD BALANCING (For Blue/Green)
# ==========================================
resource "aws_lb" "main" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_ecs_sg.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

resource "aws_lb_target_group" "blue" {
  name        = "${var.project_name}-tg-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
}

resource "aws_lb_target_group" "green" {
  name        = "${var.project_name}-tg-green"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}

# ==========================================
# 4. MODULE CALLS
# ==========================================
module "ecr" {
  source          = "./modules/ecr"
  repository_name = "${var.project_name}-ecr"
}

module "rds" {
  source               = "./modules/rds"
  subnet_ids           = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  db_security_group_id = aws_security_group.db_sg.id
}

module "ecs" {
  source           = "./modules/ecs"
  cluster_name     = "${var.project_name}-cluster"
  service_name     = "${var.project_name}-service"
  subnets          = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  security_groups  = [aws_security_group.alb_ecs_sg.id]
  target_group_arn = aws_lb_target_group.blue.arn
}

module "codedeploy" {
  source             = "./modules/codedeploy"
  app_name           = "${var.project_name}-app"
  dg_name            = "${var.project_name}-dg"
  cluster_name       = module.ecs.cluster_name
  service_name       = module.ecs.service_name
  listener_arns      = [aws_lb_listener.http.arn]
  blue_target_group  = aws_lb_target_group.blue.name
  green_target_group = aws_lb_target_group.green.name
}