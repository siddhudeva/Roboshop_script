

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
component=${1}
  curl -s -L -o /tmp/${component}.zip "https://github.com/roboshop-devops-project/${component}/archive/main.zip" &>>${LOG}
  Status $? "${component} download"
  cd /tmp

  unzip -o /tmp/${component}.zip &>>${LOG}
  Status $? "extrating"
  if [ ! -z ${component} ]; then
  mkdir -p /home/roboshop/${component} && cp -r /tmp/${component}-main/* /home/roboshop/${component}
fi
  Status $? "${component} code copying"
  cd /home/roboshop/${component}/
}

NPM() {
npm install --unsafe-prem &>>${LOG}
Status $? "Nodejs Dependencies "
}
CONFIG() {
chown roboshop:roboshop -R /home/roboshop/${component} &>>${LOG}

sed -i -e 's/MONGO_DNSNAME/mongod.roboshop.internal/' \
 -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' \
 -e 's/MONGO_ENDPOINT/mongod.roboshop.internal/' \
 -e 's/DBHOST/mysql.roboshop.internal/' \
 -e 's/CARTENDPOINT/cart.roboshop.internal/' \
 -e 's/CARTHOST/cart.roboshop.internal/' \
 -e 's/USERHOST/user.roboshop.internal/' \
 -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' \
 -e 's/AMQPHOST/rabbitmq.roboshop.internal/' \
 -e 's/RABBITMQ-IP/rabbitmq.roboshop.internal/' \
-e 's/CARTHOST/cart.roboshop.internal/' /home/roboshop/${component}/systemd.service &>>${LOG}
Status $? "config file updation"
sed -i -e '/uid/ s/1/1001/' -e '/gid/ s/1/1001/' /home/roboshop/${component}/payment.ini
mv /home/roboshop/${component}/systemd.service /etc/systemd/system/${component}.service &>>${LOG}

}
DAEMON() {
systemctl daemon-reload &>>${LOG} && systemctl enable ${component} &>>${LOG} && systemctl restart ${component}
Status $? "${component} service start"
}


NODEJS() {
  component=${1}
  yum install nodejs make gcc-c++ -y &>>${LOG}
  Status $? "Nodejs installation"
  USER
  DOWNLOAD ${component}
  NPM
  CONFIG
  DAEMON
}

DISPATCH() {
  component=${1}

yum install golang -y &>>${LOG}
Status $? "Golang installation"

  USER
  DOWNLOAD dispatch
  go mod init && go get &>>${LOG} && go build &>>${LOG}
   &>>${LOG}

  Status $? "Golang Depedencies isntallation"

  CONFIG
  DAEMON

}
