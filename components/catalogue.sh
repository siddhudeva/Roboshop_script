#!/bin/bash
#Author : Siddhu
#Date : 13/12/2021
#Description : This is a catalogue file of roboshop project
source components/common.sh

yum install nodejs make gcc-c++ -y &>>${LOG}

cat /tmp/passwd | grep roboshop &>>${LOG}
if [ $? -ne 0 ]; then
useradd roboshop &>>${LOG}
fi
Status $? "roboshop user creating"

DOWNLOAD catalogue  &>>${LOG}
Status $? "Catalogue file is created"

unzip -o /tmp/catalogue.zip &>>${LOG}
Status $? "roboshop user creating"
mv catalogue-main catalogue

chown roboshop.roboshop /home/roboshop/catalogue
Status $? "file permissions changing"
cd /home/roboshop/catalogue && npm install &>>${LOG}
Status $? "npm installation"

#NOTE: We need to update the IP address of MONGODB Server in systemd.service file
#Now, lets set up the service with systemctl.

# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue