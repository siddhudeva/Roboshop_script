#!/bin/bash
#Author : Siddhu
#Date : 14/12/2021
#Description : This is a dispatch file of roboshop project

source components/common.sh
yum install golang -y &>>${LOG}
Status $? "Golang installation"

USER dispatch
DOWNLOAD dispatch

go mod init dispatch &>>${LOG} && go get &>>${LOG} && go build &>>${LOG}
Status $? "Golang Depedencies isntallation"

CONFIG dispatch
DAEMON dispatch