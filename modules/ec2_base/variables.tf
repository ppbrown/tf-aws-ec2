
############################################
# variables.tf
############################################

variable "name_prefix" {
  type    = string
  default = "testapp"
}

variable "aws_region" {
  type    = string
}

variable "aws_account_id" {
  type = string
}

# Technically you only need to specify subnet_id.
# But if you leave that blank, and set this instead,
# we will try to pull a default subnet to use.
# Otherwise, we'll just try for default subnet on default vpc
variable "vpc_id" {
  type = string
  default = null
}

variable "subnet_id" {
  type = string
  default = null
}

#note: not "ids"
variable "vpc_security_group_names" {
  type        = list(string)
  description = "Security Group name(s) to attach to EC2 instance"
  default     = ["default"]  
  # You should probably should either change this, 
  # or ensure that "default" has sane and secure values
}


variable "instance_type" {
  type    = string
  # Change this for real deployments! This is just for test
  default = "t3.micro"
}

# define, IFF you want to be able to directly ssh in
# with a pubkey saved in AWS EC2
variable "ssh_pubkey_name" {
  type    = string
  default = null
}

variable "root_volume_gb" {
  type    = number
  default = 40
}

variable "tags" {
  type    = map(string)
  default = {}
}

# To allow for Systems Manager connect via ssm_instance_profile
variable "iam_instance_profile" {
  type = string
}

variable "user_data" {
  type    = string
  default = null
}

variable "user_data_replace_on_change" {
  type    = bool
  default = false
}


#variable "assume_role_arn" {
#  type    = string
#  default = null
#}


