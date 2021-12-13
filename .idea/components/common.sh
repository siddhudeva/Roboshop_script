

Status() {
  if [ $1 -ne 0 ]; then
  echo -e "\e[5;31m ${2} - FAILURE"
exit 1
  else
  echo -e "\e[5;32m ${2} - SUCCESS"
fi
  }

 LOG=/tmp/robo.log
 rm -rf /tmp/robo.log

 DOWNLOAD() {
  curl -s -L -o /tmp/${1}.zip "https://github.com/roboshop-devops-project/${1}/archive/main.zip"
   Status $? "${1} Downloading"
   }
