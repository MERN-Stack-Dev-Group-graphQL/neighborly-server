terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region = "eu-west-1"
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated-key" {
  key_name = "another-neighborly-server-key"
  public_key = tls_private_key.example.public_key_openssh
}

resource "aws_instance" "neighborly-server" {
  ami           = "ami-0bb3fad3c0286ebd5"
  instance_type = "t2.micro"
  key_name = aws_key_pair.generated-key.key_name
  tags = {
    Name = "neighborly-server"
  }
}
