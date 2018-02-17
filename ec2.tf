variable "sitename" {}
variable "ssh_public_key" {}

# EC2 production
resource "aws_instance" "production1" {
  ami                         = "ami-ceafcba8"
  availability_zone           = "ap-northeast-1a"
  ebs_optimized               = false
  instance_type               = "t2.micro"
  monitoring                  = true
  key_name                    = "${aws_key_pair.deployer.key_name}"
  subnet_id                   = "${aws_subnet.public-web-production.id}"
  vpc_security_group_ids      = ["${aws_security_group.app-sg.id}"]
  associate_public_ip_address = true
  private_ip                  = "10.0.0.84"
  source_dest_check           = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }

  tags {
    "Name" = "${var.sitename}-production1"
  }
}

# EC2 staging
resource "aws_instance" "staging" {
  ami                         = "ami-ceafcba8"
  availability_zone           = "ap-northeast-1a"
  ebs_optimized               = false
  instance_type               = "t2.micro"
  monitoring                  = true
  key_name                    = "${aws_key_pair.deployer.key_name}"
  subnet_id                   = "${aws_subnet.public-web-staging.id}"
  vpc_security_group_ids      = ["${aws_security_group.app-sg.id}"]
  associate_public_ip_address = true
  private_ip                  = "10.0.1.24"
  source_dest_check           = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }

  tags {
    "Name" = "${var.sitename}-staging"
  }
}

# keypair
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "${var.ssh_public_key}"
}

# elastic ip
resource "aws_eip" "production1-eip" {
  instance = "${aws_instance.production1.id}"
  vpc      = true
}

resource "aws_eip" "staging-eip" {
  instance = "${aws_instance.staging.id}"
  vpc      = true
}

output "elastic_ip_of_production" {
  value = "${aws_eip.production1-eip.public_ip}"
}

output "elastic_ip_of_staging" {
  value = "${aws_eip.staging-eip.public_ip}"
}
