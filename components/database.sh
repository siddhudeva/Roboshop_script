#!/bin/bash
#Author : siddhu
#Date : 13/12/2021
#Description : This is a Databases setup file for roboshop project
source components/common.sh

echo -e "\e[6;36m -----------------> Mongodb <--------------------\e[0m"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG}
Status $? "Download mongodb"

yum install -y mongodb-org &>>${LOG}
Status $? "Install of mongodb"

systemctl enable mongod &>>${LOG} && systemctl start mongod
Status $? "Enabling and Starting of Mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
Status $? "Configuration"

systemctl restart mongod &>>${LOG}
Status $? "Restarting Mongodb"

DOWNLOAD mongodb &>>${LOG}

cd /tmp && unzip -o mongodb.zip &>>${LOG}
Status $? "Extracting data"

cd mongodb-main && mongo < catalogue.js &>>${LOG} && mongo < users.js &>>${LOG}
Status $? "Schema added"

echo -e "\e[6;36m -----------------> redis <--------------------\e[0m"

curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG}
Status $? "Repository setup"

yum install redis -y &>>${LOG}
Status $? "Redis installation"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf &>>${LOG} && sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>>${LOG}
Status $? "configaraitons are"


systemctl enable redis &>>${LOG} && systemctl start redis
Status $? "Start Redis Database"

echo -e "\e[6;36m -----------------> rabbit mq <--------------------\e[0m"
