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

resource "aws_instance" "neighborly-server" {
  ami           = "ami-0bb3fad3c0286ebd5"
  instance_type = "t2.micro"
  key_name = "neighborly-key-test"
  tags = {
    Name = "neighborly-server"
  }
}
