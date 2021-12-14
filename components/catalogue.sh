#!/bin/bash
#Author : Siddhu
#Date : 13/12/2021
#Description : This is a catalogue file of roboshop project
source components/common.sh

yum install nodejs make gcc-c++ -y &>>${LOG}
Status $? "nodejs installation "
USER
DOWNLOAD catalogue
npm install &>>${LOG}
Status $? "${1} npm installation"
CONFIG catalogue
SYSTEMCTL catalogue
