

Status() {
  if [ $1 -ne 0 ]; then
  echo -e "\e[3;31m ${2} - FAILURE"
exit 1
  else
  echo -e "\e[3;32m ${2} - SUCCESS"
fi
  }

 LOG=/tmp/robo.log
 rm -rf /tmp/robo.log

 DOWNLOAD() {
  curl -s -L -o /tmp/${1}.zip "https://github.com/roboshop-devops-project/${1}/archive/main.zip"
   Status $? "${1} Downloading"
   cd /tmp/
   }




SYSTEM_D() {
  sed -i -e 's/MONGO_DNSNAME/mongod.roboshop.internal/' /home/roboshop/${component}-main/systemd.service &&


}

${component}=$1
UNZIP() {
rm -rf /tmp/${component}-main  && mkdir /tmp/${component}
unzip -o /tmp/${component}.zip
Status $? "Extracting ${component}"
mv /tmp/${component}-main/* /tmp/${component}/
}
INSTAL() {
yum install nodejs make gcc-c++ -y
 Status $? "Nodejs installation"
 $USER=$(id -u)
 if [ "$USER" -ne 0 ]; then
   useradd roboshop
  fi
Status $? "roboshop user ${} adding"
}