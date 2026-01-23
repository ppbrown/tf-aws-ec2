//
// Test harness to load the desired modules used in conjunction with
// EC2 instances. 
// This framework allows for control of multiple instances,
// of differing types
// Data common to all of them is loaded in this file.
// For specific instance examples, see "ec2-*.tf"
// 
// At present, internal customization of instances is done through
// inclusion of the appropriate userdata module such as
//    modules/nginx_userdata

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

