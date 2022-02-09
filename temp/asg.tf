#resource "aws_autoscaling_group" "asg" {
#  name     = "${var.COMPONENT}-${var.ENV}"
#  max_size = var.MAX_SIZE
#  min_size = var.MIN_SIZE
#
#  launch_template {
#    id      = aws_launch_template.launch-template.id
#    version = "$Latest"
#  }
#  vpc_zone_identifier = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS
#
#  tag {
#    key                 = "Name"
#    value               = "${var.COMPONENT}-${var.ENV}"
#    propagate_at_launch = true
#  }
#
#}