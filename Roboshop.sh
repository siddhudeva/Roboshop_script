#!/bin/bash
#Authour : Siddhu
#Date : 13/12/2021
#Description : This is a main file of roboshop project

#validating user
USER=$(id -u)
if [ "$USER" -ne 0 ]; then
 echo -e "\e[5;31m Please make sure you should be a root user\e[0m"
exit
fi

#validating component name entered or not
CMPNT=${1}
if [ -z ${1} ]; then
 echo -e "\e[5;31m Please make sure you entered a component name to install\e[0m"
exit
fi

#validating enterd name is correct or not
 if [ ! -e components/${CMPNT}.sh ]; then
 echo -e "\e[5;31m Entered Component Does not exists\e[0m"
 exit 1
 fi

bash component/${CMPNT}.sh