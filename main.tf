terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "InSpec Example"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "InSpec Example"
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
 }
}

resource "aws_instance" "main" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.nano"
  subnet_id     = aws_subnet.main.id

  tags = {
    Name = "my-instance"
    CostCenter = "ExampleCostCenter"
  }
}

resource "aws_iam_instance_profile" "main" {
  name = "InspecTechTalk"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "InspecTechTalk"
  path = "/"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_instance" "secondary" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.nano"
  subnet_id     = aws_subnet.main.id

  iam_instance_profile = aws_iam_instance_profile.main.id

  tags = {
    Name = "my-instance-with-role"
    CostCenter = "ExampleCostCenter"
  }
}

resource "aws_instance" "tertiary" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.nano"
  subnet_id     = aws_subnet.main.id

  tags = {
    Name = "my-instance-third"
    CostCenter = "ExampleCostCenter"
  }
}

output "instance_id" {
  value = aws_instance.main.id
}

resource "aws_s3_bucket" "main" {
  count = 3

  bucket_prefix = "inspec-tech-talk-${count.index}-"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = count.index == 0 ? { Environment = "Dev" } : null
}

resource "aws_s3_bucket_public_access_block" "main" {
  count = 3

  bucket                  = aws_s3_bucket.main[count.index].id
  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}

output "s3_bucket_id" {
  value = aws_s3_bucket.main[0].id
}
