#!/bin/bash
#Author : Siddhu
#Date : 13/12/2021
#Description : This is a Roboshop file

# Validating root user
USER= $(id -u)
if [ "$USER" -ne 0 ]; then
  echo -e "\e[5;31m Please make sure you are a root user\e[0m"
  exit
fi

# Checking wether component name is entered or not
cmpnt=${1}
if [ ! -e ${cmpnt} ]; then
echo -e "\e[5;31m Please enter a component name to install\e[0m"
  exit
fi

# Validation of enterd name is corrct

if [ -z component/${cmpnt}.sh ]; then
  echo -e "\e[5;31m Please make sure you enter a component name\e[0m"
  exit
fi

bash components/${cmpnt}.sh

