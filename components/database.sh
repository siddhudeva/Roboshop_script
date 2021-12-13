#!/bin/bash
#Author : siddhu
#Date : 13/12/2021
#Description : This is a Databases setup file for roboshop project
source components/common.sh

echo -e "\e[1;36m -----------------> Mongodb <--------------------\e[0m"
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

echo -e "\e[1;36m -----------------> redis <--------------------\e[0m"

curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG}
Status $? "Repository setup"

yum install redis -y &>>${LOG}
Status $? "Redis installation"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf &>>${LOG} && sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>>${LOG}
Status $? "configaraitons are"


systemctl enable redis &>>${LOG} && systemctl start redis
Status $? "Start Redis Database"

echo -e "\e[1;36m -----------------> rabbit mq <--------------------\e[0m"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
Status $? "Repository adding"

yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y rabbitmq-server -y &>>${LOG}
Status $? "rabbitmq installation"

systemctl enable rabbitmq-server &>>${LOG} && systemctl start rabbitmq-server &>>${LOG}
Status $? "Enabling and starting of rabbitmq"

#RabbitMQ comes with a default username / password as guest/guest. But this user cannot be used to connect. Hence we need to create one user for the application.

rabbitmqctl list_users | grep roboshop
if [ "$?" -ne 0 ]; then
   rabbitmqctl add_user roboshop roboshop123
fi
Status $? "Rabbitmq user added"

rabbitmqctl set_user_tags roboshop administrator &>>${LOG} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
Status $? "Rabbitmq user permissions"

echo -e "\e[1;36m -----------------> MySQL <--------------------\e[0m"

curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG}
Status $? "repositorie downloading"

yum install mysql-community-server -y &>>${LOG}
Status $? "MySQL installation"

systemctl enable mysqld &>>${LOG} && systemctl start mysqld
Status $? "MySQL enabling and starting"

DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}' )
echo 'show databases;' | mysql -uroot -pRoboShop@1 &>>${LOG}
if [ $? -ne 0 ]; then
  echo "ALTER user 'root'@'localhost' IDENTIFIED by 'RoboShop@1;' " >/tmp/pass.sql
  mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}" </tmp/pass.sql &>>${LOG}
fi
Status $? "MySQL user and password added"

echo 'show plugins;' | mysql -uroot -p'RoboShop@1' 2>>${LOG} | grep 'validate_password' &>>${LOG}
  if [ $? -ne 0 ]; then
    echo 'uninstall plugin validate_password;' | mysql -uroot -pRoboShop@1 &>>${LOG}
fi
Status $? "Validation Plugin unistalation"

DOWNLOAD mysql &>>${LOG}
Status $? "Validation Plugin unistalation"

cd /tmp/ && unzip -o mysql.zip && cd /tmp/mysql-main
Status $? "unzipping the files"

mysql -u root -pRoboShop@1 <shipping.sql
Status $? "schema loading"

echo -e "\e[3;35m =============Database is ready to use ==============\e[0m"
#Run the following SQL commands to remove the password policy.
#> uninstall plugin validate_password;
#Setup Needed for Application.
#As per the architecture diagram, MySQL is needed by

#Shipping Service
#So we need to load that schema into the database, So those applications will detect them and run accordingly.

#To download schema, Use the following command

# curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
#Load the schema for Services.

# cd /tmp
# unzip mysql.zip
# cd mysql-main
# mysql -u root -pRoboShop@1 <shipping.sql

