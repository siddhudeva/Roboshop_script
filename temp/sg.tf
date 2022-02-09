resource "aws_security_group" "sg-ec2" {
  name        = "${var.COMPONENT}-sg-${var.ENV}"
  description = "${var.COMPONENT}-sg-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description      = "APP"
    from_port        = var.APP_PORT
    to_port          = var.APP_PORT
    protocol         = "tcp"
    cidr_blocks      = var.APP_PORT == 80 ? [data.terraform_remote_state.vpc.outputs.VPC-CIDR] : data.terraform_remote_state.vpc.outputs.PRIVATE_CIDR
  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = concat(data.terraform_remote_state.vpc.outputs.PRIVATE_CIDR,tolist([data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]))
  }
  ingress {
    description      = "prometheus"
    from_port        = 9100
    to_port          = 9100
    protocol         = "tcp"
    cidr_blocks      = concat(data.terraform_remote_state.vpc.outputs.PRIVATE_CIDR,tolist([data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]))
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.COMPONENT}-sg-${var.ENV}"
  }
}