// http_security_group.tf
// Security group allowing inbound HTTP (80) from IPv4 internet, and all outbound IPv4.

resource "aws_security_group" "http" {
  name        = "http"
  description = "Allow inbound HTTP (80) from the internet (IPv4)"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from anywhere (IPv4)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound (IPv4)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "http"
  }
}

output "http_security_group_id" {
  description = "ID of the HTTP security group"
  value       = aws_security_group.http.id
}
