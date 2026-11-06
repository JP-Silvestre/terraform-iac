data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  page_html = <<-HTML
    <!doctype html>
    <html lang="en">
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>My IaC</title>
      </head>
      <body>
        <h1>Hi, I am ${var.owner_name} and this is my IaC</h1>
      </body>
    </html>
  HTML
}

resource "aws_security_group" "web" {
  name        = "${var.project_name}-web"
  description = "Allow public HTTP traffic to the workshop web page"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from the configured IPv4 CIDR"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allowed_http_cidr]
  }

  egress {
    description = "Allow outbound traffic for package installation and web responses"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-web-sg"
  })
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true
  user_data_replace_on_change = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted = true
  }

  user_data = <<-USERDATA
    #!/bin/bash
    set -euo pipefail
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    apt-get install -y apache2
    printf '%s' '${base64encode(local.page_html)}' | base64 --decode > /var/www/html/index.html
    systemctl enable --now apache2
  USERDATA

  tags = merge(var.tags, {
    Name = "${var.project_name}-web-server"
  })
}
