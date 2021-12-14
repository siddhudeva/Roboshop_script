#!/bin/bash
#Author : Siddhu
#Date : 14/12/2021
#Description : This is a shipping file of roboshop project

source components/common.sh
yum install maven -y &>>${LOG}
Status $? "Maven installation"
USER
DOWNLOAD
mvn clean package &>>${LOG}
Status $? "mvn dependencies"
mv target/shipping-1.0.jar shipping.jar &>>${LOG}
CONFIG
DAEMON