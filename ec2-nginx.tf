module "nginx_userdata" {
	source = "./modules/nginx_userdata"
}

# EC2 instances will be created with name of
#  "${name_prefix}-ec2"

module "nginx" {
	source = "./modules/ec2_base"

	name_prefix = "nginx"

	aws_region = var.aws_region
	aws_account_id = local.aws_account_id

	iam_instance_profile = module.ssm_profile.instance_profile_name
	security_group_ids = [
		module.security_groups.eic_ssh_security_group_id,
		module.security_groups.http_security_group_id,
	]

	user_data = module.nginx_userdata.user_data
	user_data_replace_on_change = true
}

