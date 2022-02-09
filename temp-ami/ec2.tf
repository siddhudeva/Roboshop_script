resource "aws_instance" "ami" {
  ami = data.aws_ami.ami_ec2.id
  instance_type = "t3.small"
  vpc_security_group_ids = [aws_security_group.ami_sg.id]
  tags = {
    Name = "${var.COMPONENT}-ami"
  }
}

resource "null_resource" "ami-diploy" {
  triggers = {
    instance_ids = timestamp()
  }
  provisioner = "remote-exec"
  connection {
    type     = "ssh"
    user     = local.SSH_USERNAME
    password = local.SSH_PASSWD
    host     = aws_instance.ami.public_ip
  }
  inline = [
    "ansible-pull -U https://github.com/siddhudeva/ansible-1.git roboshop-pull.yml -e COMPONENT=${var.COMPONENT} -e ENV=ENV -e APP_VERSION=${var.APP_VERSION} -e NEXUS_USERNAME=${local.NEXUS_USERNAME} -e NEXUS_PASSWORD=${local.NEXUS_PASSWD}"
  ]
}
