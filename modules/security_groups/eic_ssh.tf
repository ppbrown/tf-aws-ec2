// Ensure security group for "ec2 instance connect" usage
// If you want to use EC2 Instance Connect instead of Session Manager,
// you need this security group (inbound SSH 22 from AWS EIC service)


data "aws_ec2_managed_prefix_list" "ec2_instance_connect" {
  name = "com.amazonaws.${var.aws_region}.ec2-instance-connect"
}

locals {
  sg_name = "eic_ssh"
}

resource "aws_security_group" "eic_ssh" {
  name        = local.sg_name
  description = "Allow SSH from EC2 Instance Connect"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.ec2_instance_connect.id]
  }

  egress {
    description = "All outbound (IPv4)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

output "eic_ssh_security_group_id" {
  description = "ID of the EC2 Instance Connect security group"
  value = aws_security_group.eic_ssh.id
}

output "eic_ssh_security_group_name" {
  value = local.sg_name
}

