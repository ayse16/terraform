terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.8.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
  
}

data "aws_ami" "project_ami"{
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "owner-alias"
        values = ["amazon"]
    }

    filter {
        name = "name"
        values = ["amzn2-ami-hvm*"]
    }
    
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_instance" "project_roman" {
    ami = data.aws_ami.project_ami.id
    instance_type = "t2.micro"
    key_name = "firstkey"
    security_groups = ["project-roman-sg"]
    user_data = file("./project_script.sh")
    tags = {
        Name = "roman-converter-instance"
    }
}

resource "aws_security_group" "project_sec"{
    name = "project-roman-sg"
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

output "dnsname" {
    value = "http://${aws_instance.project_roman.public_ip}"
  
}