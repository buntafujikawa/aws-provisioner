resource "aws_vpc" "vpc-main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags {
    Name = "vpc-main"
  }
}

# subnet public
resource "aws_subnet" "public-web-production" {
  vpc_id                  = "${aws_vpc.vpc-main.id}"
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags {
    Name = "public-web-production"
  }
}

resource "aws_subnet" "public-web-staging" {
  vpc_id                  = "${aws_vpc.vpc-main.id}"
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags {
    "Name" = "public-web-staging"
  }
}

# subnet private
resource "aws_subnet" "private-db-production" {
  vpc_id            = "${aws_vpc.vpc-main.id}"
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1a"
  tags {
    Name = "private-db-production"
  }
}

resource "aws_subnet" "private-db-staging" {
  vpc_id            = "${aws_vpc.vpc-main.id}"
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-1c"
  tags {
    Name = "private-db-staging"
  }
}

# subnet db
resource "aws_db_subnet_group" "db-subnet" {
  name        = "${var.sitename}-db"
  description = "${var.sitename}-rds-group"
  subnet_ids  = ["${aws_subnet.private-db-production.id}", "${aws_subnet.private-db-staging.id}"]
}

# internet gateway
resource "aws_internet_gateway" "gateway" {
  vpc_id = "${aws_vpc.vpc-main.id}"
  tags {
    Name = "gateway-for-${var.sitename}"
  }
}

# route table
resource "aws_route_table" "vpc-main-production-rtb" {
  vpc_id = "${aws_vpc.vpc-main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway.id}"
  }

  tags {
    Name = "vpc-main-production-rtb"
  }
}

resource "aws_route_table" "vpc-main-staging-rtb" {
  vpc_id     = "${aws_vpc.vpc-main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway.id}"
  }

  tags {
    "Name" = "vpc-main-staging-rtb"
  }
}

resource "aws_main_route_table_association" "main-rtb-of-main-vpc" {
  vpc_id         = "${aws_vpc.vpc-main.id}"
  route_table_id = "${aws_route_table.vpc-main-production-rtb.id}"
}

resource "aws_route_table_association" "vpc-main-with-production-public-subnet" {
  route_table_id = "${aws_route_table.vpc-main-production-rtb.id}"
  subnet_id = "${aws_subnet.public-web-production.id}"
}

resource "aws_route_table_association" "vpc-main-with-production-private-subnet" {
  route_table_id = "${aws_route_table.vpc-main-production-rtb.id}"
  subnet_id = "${aws_subnet.private-db-production.id}"
}

resource "aws_route_table_association" "vpc-main-with-staging-public-subnet" {
  route_table_id = "${aws_route_table.vpc-main-staging-rtb.id}"
  subnet_id = "${aws_subnet.public-web-staging.id}"
}

resource "aws_route_table_association" "vpc-main-with-staging-private-subnet" {
  route_table_id = "${aws_route_table.vpc-main-staging-rtb.id}"
  subnet_id = "${aws_subnet.private-db-staging.id}"
}
