

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

#DOWNLOAD() {
# curl -s -L -o /tmp/${1}.zip "https://github.com/roboshop-devops-project/${1}/archive/main.zip"
#  Status $? "${1} Downloading"
#  cd /tmp
#  unzip -o /tmp/${1}.zip &>>${LOG}
#  if [ ! -z "${Component}" ]; then
#  rm -rf /home/roboshop/${1} &>>${LOG} && mkdir -p /home/roboshop/${1} && cp -r /tmp/${1}-main/* /home/roboshop/${1}
#  fi
#}
DOWNLOAD () {
  curl -s -L -o /tmp/${1}.zip "https://github.com/roboshop-devops-project/${1}/archive/main.zip" &>>${LOG}
  Status $? "Download ${1} Code"
  cd /tmp
  unzip -o /tmp/${1}.zip &>>${LOG}
  Status $? "Extract ${1} Code"
  if [ ! -z "${1}" ]; then
    rm -rf /home/roboshop/${1} && mkdir -p /home/roboshop/${1} && cp -r /tmp/${1}-main/* /home/roboshop/${1} &>>${LOG}
    STAT_CHECK $? "Copy ${1} Content"
  fi
}

CONFIG() {
    sed -i -e 's/MONGO_DNSNAME/catalogue.roboshop.internal/' /home/roboshop/${1}/systemd.service &>>${LOG}
   mv /home/roboshop/${1}/systemd.service /etc/systemd/system/${1}.service
   }
       Status $? "${1} configuration"

SYSTEMCTL() {
  systemctl daemon-reload &>>${LOG} && systemctl enable ${1}.service &>>${LOG} && systemctl restart ${1}.service
   Status $? "${1} services"
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



