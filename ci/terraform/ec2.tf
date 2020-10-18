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
  region = "eu-east-1"
}

resource "aws_instance" "neighborly-server" {
  ami           = "ami-0947d2ba12ee1ff75"
  instance_type = "t2.micro"
  key_name = "jess-key-pair-test"
  tags = {
    Name = "neighborly-server"
  }
}
