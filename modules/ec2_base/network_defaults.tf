
# Pull this out here just to keep main.tf more readable.
# Allow for use of default fallbacks for vpc and subnet id,
# but still accept overrides via var.subnet_id and var.vpc_id

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


output "vpc_id" {
  value = local.effective_vpc_id
}

output "subnet_id" {
  value = local.effective_subnet_id
}

