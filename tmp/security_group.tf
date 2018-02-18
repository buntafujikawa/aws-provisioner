resource "aws_security_group" "elb-sg" {
  name   = "elb-sg"
  vpc_id = "${aws_vpc.vpc-main.id}"
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
  description = "elb security group"
  tags {
    Name = "elb-sg"
  }
}

resource "aws_security_group" "app-sg" {
  name   = "app-sg"
  vpc_id = "${aws_vpc.vpc-main.id}"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.elb-sg.id}"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  description = "app security group"
  tags {
    Name = "app-sg"
  }
}

resource "aws_security_group" "rds-sg" {
  name   = "rds-sg"
  vpc_id = "${aws_vpc.vpc-main.id}"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.app-sg.id}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  description = "rds security group"
  tags {
    Name = "rds-sg"
  }
}
