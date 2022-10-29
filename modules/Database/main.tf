# Database Instance 
resource "aws_db_instance" "Database_EC2" {
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  multi_az               = var.multi_az
  db_subnet_group_name   = aws_db_subnet_group.Database_Subnet_Group.name
  username               = "MasterUsername"
  password               = aws_secretsmanager_secret_version.secret_val.id
  skip_final_snapshot    = true
  vpc_security_group_ids = [var.security_groups]
}

resource "random_password" "default_password" {
  length           = 20
  special          = false
}

resource "aws_secretsmanager_secret" "RDS_MasterPW" {
  name = "RDS-MasterPW"
}

resource "aws_secretsmanager_secret_version" "secret_val" {
  secret_id     = aws_secretsmanager_secret.RDS_MasterPW.id
  secret_string = jsonencode({ "password" : random_password.default_password.result })
}

resource "aws_db_subnet_group" "Database_Subnet_Group" {
  name       = "db_sub_grp"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "DB_Subnet_Group"
  }
}