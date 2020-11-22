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

resource "aws_instance" "neighborly_server_dev" {
  ami           = "ami-0947d2ba12ee1ff75"
  instance_type = "t2.micro"
  security_groups = [ "sg-0badf30d69e4dca5d" ]
  key_name = "neighborly-server-test"
  tags = {
    Name = "neighborly_server_dev"
  }
}
