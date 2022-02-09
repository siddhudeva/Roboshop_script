data "aws_ami" "ami_ec2" {
  most_recent      = true
  name_regex       = "base_ami"
  owners           = ["self"]
}


////here we are trying to get secrets form aws secrets form aws secret manager
data "aws_secretsmanager_secret" "Secrets" {
  name = "nexus"
}
///// why????
data "aws_secretsmanager_secret_version" "secret-ssh" {
  secret_id = data.aws_secretsmanager_secret.Secrets.id
}


locals {
  SSH_USERNAME   = jsondecode(data.aws_secretsmanager_secret_version.secret-ssh.secret_string)["SSH_USERNAME"]
  SSH_PASSWD     = jsondecode(data.aws_secretsmanager_secret_version.secret-ssh.secret_string)["SSH_PASSWD"]
  NEXUS_USERNAME = nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.secret-ssh.secret_string)["NEXUS_USR"])
  NEXUS_PASSWD   = nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.secret-ssh.secret_string)["NEXUS_PSW"])
}