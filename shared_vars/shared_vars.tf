output "vpcid" {
  value = "${local.vpcid}"
}

output "publicsubnetid1" {
  value = "${local.publicsubnetid1}"
}

output "publicsubnetid2" {
  value = "${local.publicsubnetid2}"
}

output "privatesubnetid" {
  value = "${local.privatesubnetid}"
}

output "env_suffix" {
  value = "${local.env}"
}

locals {
  env               = "${terraform.workspace}"
  vpcid_env = {
      default       = "vpc-08c5685456033a302"  # use default vpc for this project, usually it will be separated
      staging       = "vpc-08c5685456033a302"
      production    = "vpc-08c5685456033a302"
  }
  vpcid             = "${lookup(local.vpcid_env, local.env)}"

  publicsubnetid1_env = {
      default       = "subnet-08eeb8f75cd1f2abc"  # use default vpc for this project, usually it will be separated
      staging       = "subnet-08eeb8f75cd1f2abc"
      production    = "subnet-08eeb8f75cd1f2abc"
  }
  publicsubnetid1    = "${lookup(local.publicsubnetid1_env, local.env)}"

  publicsubnetid2_env = {
      default       = "subnet-02dbc334c8e5bb05a"  # use default vpc for this project, usually it will be separated
      staging       = "subnet-02dbc334c8e5bb05a"
      production    = "subnet-02dbc334c8e5bb05a"
  }
  publicsubnetid2    = "${lookup(local.publicsubnetid2_env, local.env)}"

  privatesubnetid_env = {
      default       = "subnet-06669d4345b8e4e99"  # use default vpc for this project, usually it will be separated
      staging       = "subnet-06669d4345b8e4e99"
      production    = "subnet-06669d4345b8e4e99"
  }
  privatesubnetid             = "${lookup(local.privatesubnetid_env, local.env)}"
}
