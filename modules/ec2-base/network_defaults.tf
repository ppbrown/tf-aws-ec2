
# Pull this out here just to keep main.tf more readable.
# Allow for use of default fallbacks for vpc and subnet id.
# Normally though you would want to set explicit values 
# in variables.tf

# Look up default vpc for this account as a fallback
data "aws_vpc" "default" {
  default = true
}

locals {
  effective_vpc_id = coalesce(var.vpc_id, data.aws_vpc.default.id)
}

# get list of all subnets in selected vpc, in case we have to calculate
# a fallback subnet id.
data "aws_subnets" "in_vpc" {
  filter {
    name   = "vpc-id"
    values = [local.effective_vpc_id]
  }
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

locals {
  effective_subnet_id = coalesce(var.subnet_id, sort(data.aws_subnets.in_vpc.ids)[0])
}

data "aws_security_group" "by_name" {
  for_each = toset(var.vpc_security_group_names)

  name   = each.value
  vpc_id = local.effective_vpc_id
}




# If you want to use EC2 Instance Connect instead of Session Manager,
# you need this security group (inbound SSH 22 from AWS EIC service)

data "aws_ec2_managed_prefix_list" "ec2_instance_connect" {
  name = "com.amazonaws.${var.aws_region}.ec2-instance-connect"
}

resource "aws_security_group" "eic_ssh" {
  name        = "eic-ssh"
  description = "Allow SSH from EC2 Instance Connect"
  vpc_id      = local.effective_vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.ec2_instance_connect.id]
  }
}

output "eic_ssh_security_group_id" {
  value = aws_security_group.eic_ssh.id
}

