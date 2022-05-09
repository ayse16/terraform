terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.8.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "tf_ami"{
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name = "name"
    values = ["amzn2-ami-kernel-5.10*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }  
}

variable "tf-tags"{
  default = ["First", "Second"]
}

resource "aws_instance" "my-ec2" {
  # get Amazon Linux 2 AMI
  ami             = data.aws_ami.tf_ami.id
  instance_type   = "t2.micro"
  count = 2
  key_name        = "firstkey"
  security_groups = ["tf-homework-sg"]
  tags = {
    Name = "Terraform ${element(var.tf-tags, count.index )} instance"
  }
  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/Users/ayseartiklar/Downloads/firstkey.pem")
  }
  user_data = <<EOF
                #! /bin/bash
                #update os
                yum update -y
                #install apache server
                yum install -y httpd
                # create a custom index.html file
                echo "<html>
                <body>
                    <h1>Hello World from My First Terraform Web Server</h1>
                </body>
                </html>" > /var/www/html/index.html
                # start apache server
                systemctl start httpd
                systemctl enable httpd
                EOF
  
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> public.txt"

  }

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private.txt"

  }
}

output "public_ip" {
    value = "${join(", ", aws_instance.my-ec2.*.public_ip)}"
}

resource "aws_security_group" "tf-sec-gr" {
  name = "tf-homework-sg"
  tags = {
    Name = "tf-homework-sg"
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}






