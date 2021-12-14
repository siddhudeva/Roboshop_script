#!/bin/bash
#Author : Siddhu
#Date : 13/12/2021
#Description : This is a catalogue file of roboshop project
source components/common.sh

yum install nodejs make gcc-c++ -y &>>${LOG}
Status $? "nodejs installation "
id roboshop &>>${LOG}
if [ $? -ne 0 ]; then
  useradd roboshop
Status $? "roboshop user creating"
fi
DOWNLOAD catalogue
npm install &>>${LOG}
   Status $? ${1} "npm installation"
