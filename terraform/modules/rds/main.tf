resource "aws_security_group" "rds" {
  name   = "rds-postgres-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.eks_node_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "rds-subnet-group"
  subnet_ids = var.db_subnets
}

resource "random_password" "db" {
  length  = 16
  special = true
}

resource "aws_db_instance" "postgres" {
  identifier = "prod-postgres"

  engine         = "postgres"
  engine_version = "15"
  instance_class = "db.t3.medium"

  allocated_storage = 50
  max_allocated_storage = 200

  db_name  = var.db_name
  username = var.db_username
  password = random_password.db.result

  multi_az               = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.this.name

  backup_retention_period = 7
  skip_final_snapshot     = false
}

