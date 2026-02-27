resource "aws_db_subnet_group" "this" {
  name       = "nithin-task-11-db-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "this" {
  identifier           = "nithin-task-11-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "15" 
  instance_class       = "db.t3.micro"
  db_name              = "strapi"
  username             = "nithinadmin"
  password             = "SecurePassword123!" # In production, use Secrets Manager
  parameter_group_name = "default.postgres15"
  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_security_group_id]
  skip_final_snapshot  = true
  publicly_accessible  = false
}