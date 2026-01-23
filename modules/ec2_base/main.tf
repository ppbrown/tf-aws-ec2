terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region              = var.aws_region
  allowed_account_ids = [var.aws_account_id]
}

data "aws_ami" "amazon_linux_latest" {
  most_recent = true
  owners      = ["amazon"]

  # Amazon Linux 2023 (x86_64).
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  effective_user_data = coalesce(
    var.user_data,
    templatefile("${path.module}/user_data.generic", {})
  )
}


resource "aws_instance" "this" {
  ami                    = data.aws_ami.amazon_linux_latest.id
  instance_type          = var.instance_type
  subnet_id              = local.effective_subnet_id
  vpc_security_group_ids = var.security_group_ids

  # Optional:
  # associate_public_ip_address = true

  # Optional. Defaults to null
  key_name               = var.ssh_pubkey_name

  # Security tooling to allow IMDS metadata queries,
  # but stay reasonably secure
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  iam_instance_profile = var.iam_instance_profile

  user_data                   = local.effective_user_data
  user_data_replace_on_change = var.user_data_replace_on_change

  monitoring              = true  # Note: this costs money
  disable_api_termination = false

  tags = merge(var.tags, { Name = "${var.name_prefix}-ec2" })
}
