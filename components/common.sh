

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
USER() {
id roboshop &>>${LOG}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${LOG}
Status $? "roboshop user creating"
fi
}

 DOWNLOAD() {
  curl -s -L -o /tmp/${component}.zip "https://github.com/roboshop-devops-project/${component}/archive/main.zip"
   Status $? "${component} Downloading"
   cd /tmp
   unzip -o /tmp/${component}.zip &>>${LOG}
   if [ ! -z "${Component}" ]; then
   rm -rf /home/roboshop/${component}-main &>>${LOG} && mkdir -p /home/roboshop/${component} && cp -r /tmp/${component}-main/* /home/roboshop/${component}
fi
 }

CONFIG() {
  sed -i -e 's/MONGO_DNSNAME/catalogue.roboshop.internal/' /home/roboshop/${component}/systemd.service &>>${LOG}
   Status $? "${component} configuration"
   mv /home/roboshop/${component}/systemd.service /etc/systemd/system/${component}.service
   }

SYSTEMCTL() {
  systemctl daemon-reload &>>${LOG} && systemctl enable ${component}.service &>>${LOG} && systemctl restart ${component}.service
   Status $? "${component} services"
 }

 NODEJS () {
   component=${1}
yum install nodejs make gcc-c++ -y &>>${LOG}
Status $? "nodejs installation "
USER
DOWNLOAD
npm install &>>${LOG}
Status $? "${1} npm installation"
CONFIG
SYSTEMCTL
}



