variable "db_engine_name" {}
variable "db_engine_version" {}
variable "db_engine_family" {}
variable "production_instance_class" {}
variable "staging_instance_class" {}
variable "db_username" {}
variable "db_password" {}

resource "aws_db_instance" "production" {
  identifier                = "${var.sitename}-production"
  // TODO インスタンスクラスを変更した場合にストレージも合わせて変更できるようにする
  allocated_storage         = 20 # RDS MySQL でサポートされる非プロビジョンドストレージは 20 ～ 6144 GB です
  storage_type              = "gp2" # 汎用 (SSD) 小規模から中規模のデータベースに最適
  engine                    = "${var.db_engine_name}"
  engine_version            = "${var.db_engine_family}"
  instance_class            = "${var.production_instance_class}"
  name                      = "${var.sitename}_db_production"
  username                  = "${var.db_username}"
  password                  = "${var.db_password}"
  port                      = 3306
  publicly_accessible       = false
  availability_zone         = "ap-northeast-1a"
  security_group_names      = []
  vpc_security_group_ids    = ["${aws_security_group.rds-sg.id}"]
  db_subnet_group_name      = "${aws_db_subnet_group.db-subnet.name}"
  parameter_group_name      = "${aws_db_parameter_group.default.name}"
  multi_az                  = false
  backup_retention_period   = 7
  backup_window             = "02:00-03:00"
  maintenance_window        = "thu:03:00-thu:04:00"
  final_snapshot_identifier = "${var.sitename}-production-final"
}

resource "aws_db_instance" "staging" {
  identifier                = "${var.sitename}-staging"
  allocated_storage         = 20
  storage_type              = "gp2"
  engine                    = "${var.db_engine_name}"
  engine_version            = "${var.db_engine_family}"
  instance_class            = "${var.production_instance_class}"
  name                      = "${var.sitename}_db_staging"
  username                  = "${var.db_username}"
  password                  = "${var.db_password}"
  port                      = 3306
  publicly_accessible       = false
  availability_zone         = "ap-northeast-1c"
  security_group_names      = []
  vpc_security_group_ids    = ["${aws_security_group.rds-sg.id}"]
  db_subnet_group_name      = "${aws_db_subnet_group.db-subnet.name}"
  parameter_group_name      = "${aws_db_parameter_group.default.name}"
  multi_az                  = false
  backup_retention_period   = 7
  backup_window             = "02:00-03:00"
  maintenance_window        = "thu:03:00-thu:04:00"
  final_snapshot_identifier = "${var.sitename}-staging-final"
}

resource "aws_db_parameter_group" "default" {
  name        = "${var.sitename}-${var.db_engine_name}-pg"
  family      = "${var.db_engine_name}${var.db_engine_family}"
  description = "parameter group for ${var.db_engine_name}${var.db_engine_family}"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }

  parameter {
    name  = "time_zone"
    value = "Asia/Tokyo"
  }
}
