resource "aws_launch_template" "launch-template" {
  name     = "${var.COMPONENT}.${var.ENV}"
  image_id = data.aws_ami.ami_ec2.id
  instance_market_options {
    market_type = "spot"
    spot_options {
      spot_instance_type = "one-time"
    }
  }

  instance_type          = var.INSTANCES_TYPE
  vpc_security_group_ids = [aws_security_group.sg-ec2.id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.COMPONENT}.${var.ENV}"
    }
  }
  user_data = filebase64("${path.module}/env-${var.ENV}.sh")
}