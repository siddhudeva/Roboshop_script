

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
   Status $? ${1} "Downloading"
   cd /tmp/
   rm -rf /tmp/${1}-main
   unzip ${1}.zip &>>${LOG} && mv ${1}-main ${1} && cd ${1}
   }



