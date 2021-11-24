module "shared_vars" {
  source = "../shared_vars"
}

variable "private_sg_id" {
  
}

variable "tg_arn" {
  
}

locals {
  env = "${terraform.workspace}"
  ami_id_env = {
      default       = "ami-0bf8b986de7e3c7ce"  # use default vpc for this project, usually it will be separated
      staging       = "ami-0bf8b986de7e3c7ce"
      production    = "ami-0bf8b986de7e3c7ce"
  }
  amiid             = "${lookup(local.ami_id_env, local.env)}"

  instance_type_env = {
    default       = "t2.micro"  # use default vpc for this project, usually it will be separated
    staging       = "t2.micro"
    production    = "t2.medium"
  }
  instancetype = "${lookup(local.instance_type_env, local.env)}"

  keypairname_env = {
    default       = "aws_project_tf_kp_staging"  # use default vpc for this project, usually it will be separated
    staging       = "aws_project_tf_kp_staging"
    production    = "aws_project_tf_kp_production"
  }
  keypairname = "${lookup(local.keypairname_env, local.env)}"

  asgdesired_env = {
    default       = "1"  # use default vpc for this project, usually it will be separated
    staging       = "1"
    production    = "2"
  }
  asgdesired = "${lookup(local.asgdesired_env, local.env)}"

  asgmin_env = {
    default       = "1"  # use default vpc for this project, usually it will be separated
    staging       = "1"
    production    = "2"
  }
  asgmin = "${lookup(local.asgmin_env, local.env)}"

  asgmax_env = {
    default       = "2"  # use default vpc for this project, usually it will be separated
    staging       = "2"
    production    = "4"
  }
  asgmax = "${lookup(local.asgmax_env, local.env)}"
}

resource "aws_launch_configuration" "sampleapp_lc" {
  name          = "sampleapp_lc_${local.env}"
  image_id      = "${local.amiid}"
  instance_type = "${local.instancetype}"
  key_name = "${local.keypairname}"
  user_data = "${file("assets/userdata.txt")}"
  security_groups = ["${var.private_sg_id}"]
}

resource "aws_autoscaling_group" "sampleapp_asg" {
  name                 = "sampleapp_autoscaling_group_${module.shared_vars.env_suffix}"
  max_size             = "${local.asgmax}"
  min_size             = "${local.asgmin}"
  desired_capacity     = "${local.asgdesired}"
  launch_configuration = "${aws_launch_configuration.sampleapp_lc.name}"
  vpc_zone_identifier  = ["${module.shared_vars.publicsubnetid1}"]
  target_group_arns    = ["${var.tg_arn}"]
  tags = concat(
    [
      {
        "key"                 = "Name"
        "value"               = "SampleApp_${module.shared_vars.env_suffix}"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "Environment"
        "value"               = "${module.shared_vars.env_suffix}"
        "propagate_at_launch" = true
      }
    ]
  )
}