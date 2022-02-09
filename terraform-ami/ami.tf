#resource "aws_ami_from_instance" "ami" {
#  depends_on = [null_resource.ami-diploy]    //depends on will be used to make a condition to the terraform to create aws ami after provision of ami-diploy
#  name               = "${var.COMPONENT}-${var.APP_VERSION}"
#  source_instance_id = aws_instance.ami.id
#  tags = {
#    Name = "${var.COMPONENT}-${var.APP_VERSION}"
#  }
#}