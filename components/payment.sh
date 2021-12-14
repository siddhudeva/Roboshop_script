#!/bin/bash
##Author : siddhu
##Date : 13/12/2021
##Description : This is a Databases setup file for roboshop project
source components/common.sh
yum install python36 gcc python3-devel -y &>>${LOG}
Status $? "PYTHON36 installation"
USER
DOWNLOAD payment
pip3 install -r requirements.txt &>>${LOG}
Status $? "Downloading Dependncies"
CONFIG payment
DAEMON payment
