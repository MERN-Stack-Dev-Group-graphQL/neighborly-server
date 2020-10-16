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

resource "aws_key_pair" "generated-key" {
  key_name = "neighborly-key-test"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCCagESFckn8HRXv0gKHAI6M2x00Ukt2OETV2JtwIClXzxALuFum98I8Xj67dGxEp5oTnddsMFXw5MZ/goT2DsB43USHDWHBNdmuaCD1Lk3b/Iq4Q2JYiH8vbnCfgf7B+tfFqU0ejSiDlI9fAXbZFeu2olGFdr489oQQIdZ2vokvL7B89vWSGkjZX154kQStZ8EKuq22N04VPfA611JObuixvHqnjwdxS8e0yGbKj/okSXxvIcautPFiu8y/Jbw+gCDdcRxZv9hdZ9qja9ng1HZMlhMPgulomudefkNvQ3O5jRevWK6wBiIKzhXrcaCfX4g5t5+03x6rqub1mKSYuaT"
}

resource "aws_instance" "neighborly-server" {
  ami           = "ami-0bb3fad3c0286ebd5"
  instance_type = "t2.micro"
  key_name = "neighborly-key-test"
  tags = {
    Name = "neighborly-server"
  }
}
