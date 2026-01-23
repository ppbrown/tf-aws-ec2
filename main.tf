
#
# Test harness to load the desired modules
#

data "aws_caller_identity" "current" {}

locals {
	aws_account_id = data.aws_caller_identity.current.account_id
}

module "ssm_profile" {
	source = "./modules/ssm_instance_profile"
}

module "security_groups" {
	source = "./modules/security_groups"
	vpc_id = var.vpc_id
	aws_region = var.aws_region
}

