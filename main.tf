
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


module "nginx_userdata" {
	source = "./modules/nginx_userdata"
}


module "ec2_instance" {
	source = "./modules/ec2_base"

	name_prefix = var.name_prefix

	aws_region = var.aws_region
	aws_account_id = local.aws_account_id

	iam_instance_profile = module.ssm_profile.instance_profile_name

	user_data = module.nginx_userdata.user_data
	user_data_replace_on_change = true
}
