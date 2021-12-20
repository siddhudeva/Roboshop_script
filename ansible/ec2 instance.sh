#!/bin/bash

if [ -z ${1} ]; then
  echo -e "\e[1;31m enter a item name\e[0m"
  exit 1
fi
component=${1}

CREATE_EC2() {
ID_ZONE=Z0094801QOS7DHKY0DMZ
L_TEMPID=lt-0078ea8f7c4e4b68e

#ec2 instance creating
 aws ec2 describe-instances --filters Name=tag:Name,Values=${component} | jq .Reservations[].Instances[].State.Name | sed 's/"//g' | grep -E 'run|stop' | jq
 if [ $? -ne 0 ]; then
    echo -e "\e[1;31m This instance is already there\e[0m"
  else
aws ec2 run-instances --launch-template LaunchTemplateId=${L_TEMPID} --tag-specifications "ResourceType=instance,Tags=[{Key=name,Value=${component}}]" | jq
fi
 IPADDRESS=$(aws ec2 describe-instances --filter "Name=tag:Name,Values=${component}" | jq .Reservations[].Instances[].PrivateIpAddress | sed 's/"//g' | grep -v null )

sleep 10

#updateing route53
}

# for instent creation of ec2 instances using loops function to create
if [ ${component} == "all" ]; then
   for ec2s in frontend catalogue rabbitmq;do
    component=${ec2s}
    CREATE_EC2
   done
  else
  CREATE_EC2
fi
