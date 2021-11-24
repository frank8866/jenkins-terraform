module "shared_vars" {
    source = "../shared_vars"
}

resource "aws_security_group" "public_sg" {
    name = "public_sg_${module.shared_vars.env_suffix}"
    description = "public security group for load balancers in ${module.shared_vars.env_suffix}"
    vpc_id = "${module.shared_vars.vpcid}"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    } 
}

output "public_sg_id" {
  value = "${aws_security_group.public_sg.id}"
}

resource "aws_security_group" "private_sg" {
    name = "private_sg_${module.shared_vars.env_suffix}"
    description = "private security group for EC2 in ${module.shared_vars.env_suffix}"
    vpc_id = "${module.shared_vars.vpcid}"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = ["${aws_security_group.public_sg.id}"]
    }
    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    } 
}

output "private_sg_id" {
  value = "${aws_security_group.private_sg.id}"
}