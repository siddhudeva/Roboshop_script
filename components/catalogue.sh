#!/bin/bash
#Author : Siddhu
#Date : 13/12/2021
#Description : This is a catalogue file of roboshop project
source components/common.sh

yum install nodejs make gcc-c++ -y &>>${LOG}
USER
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG}
cd /tmp

unzip -o /tmp/catalogue.zip &>>${LOG}

mkdir -p /home/roboshop/catalogue && cp -r /tmp/catalogue-main/* /home/roboshop/catalogue

npm install --unsafe-prem &>>${LOG}

chown roboshop:roboshop -R /home/roboshop/catalogue &>>${LOG}

sed -i -e 's/MONGO_DNSNAME/mongod.roboshop.internal/' /home/roboshop/catalogue/systemd.service &>>${LOG}

mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>${LOG}

systemctl daemon-reload &>>${LOG} && systemctl enable catalogue &>>${LOG} && systemctl restart catalogue


