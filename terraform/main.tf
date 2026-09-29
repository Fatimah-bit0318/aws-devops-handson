terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "crecita_sg" {
  name        = "crecita-sg"
  description = "Allow SSH and React app traffic"
  vpc_id      = "vpc-09fc216cba943574a"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "React App"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Crecita-Security-Group"
  }
}

resource "aws_instance" "crecita_ec2" {
  ami           = "ami-0b245cc5f82576748"
  instance_type = "t3.micro"

  subnet_id = "subnet-0883c71f291e646bc"

  vpc_security_group_ids = [
    aws_security_group.crecita_sg.id
  ]

  tags = {
    Name = "Crecita-DevOps"
  }
}