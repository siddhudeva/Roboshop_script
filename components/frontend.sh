#!/bin/bash
#Author : siddhu
#Date : 13/12/2021
#Description : This is a Frontend setup file for roboshop project
source components/common.sh

yum install nginx -y &>>${LOG}
Status $? "Nginx installation"

systemctl enable nginx &>>${LOG} && systemctl start nginx &>>${LOG}
Status $? "Enable and start of Nginx"

DOWNLOAD frontend &>>${LOG}

rm -rf /usr/share/nginx/html/* &>>${LOG}  && cd /usr/share/nginx/html && unzip -o /tmp/frontend.zip &>>${LOG}
Status $? "extracting files"

mv frontend-main/* . &>>${LOG} && mv static/* . &>>${LOG}
Status $? "adding all data"

rm -rf frontend-master static README.md &>>${LOG}
Status $? "removing unwanted files"

sed -i -e '/catalogue/ s/"http://localhost"/catalogue.roboshop.internal/'\
-e '/cart/ s/"http://localhost"/cart.roboshop.internal/'\
-e '/payment/ s/"http://localhost"/payment.roboshop.internal/'\
-e '/shipping/ s/"http://localhost"/shipping.roboshop.internal/' \
-e '/user/ s/"http://localhost"/user.roboshop.internal/'
 localhost.conf

mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
Status $? "Configration file location changed"

systemctl restart nginx &>>${LOG}
Status $? "Restarting Nginx"
