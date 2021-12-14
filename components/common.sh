

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
 DOWNLOAD ${component}
}

${component}=$1
 DOWNLOAD() {
  curl -s -L -o /tmp/${component}.zip "https://github.com/roboshop-devops-project/${component}/archive/main.zip"
   Status $? "${component} Downloading"
   cd /tmp
   unzip /tmp/${component}.zip &>>${LOG}
   if [ ! -z "${Component}" ]; then
   rm -rf /home/roboshop/${component} &>>${LOG} && mkdir -p /home/roboshop/${component} && mv /tmp/${component}-main/* /home/roboshop/${component}
 }



