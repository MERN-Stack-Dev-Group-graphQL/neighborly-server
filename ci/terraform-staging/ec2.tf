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
  region = "us-east-1"
}

# resource "aws_security_group" "allow_all" {
#   name = "allow all"
#   description = "allow all"  
#   id = "sg-0badf30d69e4dca5d"
# }

resource "aws_s3_bucket" "b" {
  bucket = "neighborly-tools-staging-build"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_instance" "neighborly_server_staging" {
  ami           = "ami-0fdea5dc1f685de67"
  instance_type = "t2.micro"
  security_groups = ["inbound-ssh-general"]
  key_name = "neighborly-server-key"
  tags = {
    Name = "neighborly_server_staging"
  }
}
