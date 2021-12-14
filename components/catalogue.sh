#!/bin/bash
#Author : Siddhu
#Date : 13/12/2021
#Description : This is a catalogue file of roboshop project
source components/common.sh

yum install nodejs make gcc-c++ -y &>>${LOG}
Status $? "Nodejs installation"
USER
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG}
Status $? "catalogue download"
cd /tmp

unzip -o /tmp/catalogue.zip &>>${LOG}
Status $? "extraxting"

mkdir -p /home/roboshop/catalogue && cp -r /tmp/catalogue-main/* /home/roboshop/catalogue
cd /home/roboshop/catalogue/
npm install --unsafe-prem &>>${LOG}
Status $? "Nodejs Dependencies "

chown roboshop:roboshop -R /home/roboshop/catalogue &>>${LOG}

sed -i -e 's/MONGO_DNSNAME/mongod.roboshop.internal/' /home/roboshop/catalogue/systemd.service &>>${LOG}
Status $? "config file updation"

mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>${LOG}

systemctl daemon-reload &>>${LOG} && systemctl enable catalogue &>>${LOG} && systemctl restart catalogue
Status $? "catalogue service start"


