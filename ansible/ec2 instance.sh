#!/bin/bash

if [ -z ${1} ]; then
  echo -e "\e[1;31m enter a item name\e[0m"
  exit 1
fi
component=${1}
ENV=${2}
if [ ! -z ${ENV} ] ; then
  ENV="-${ENV}"
fi

CREATE_EC2() {
ID_ZONE=Z0094801QOS7DHKY0DMZ
L_TEMPID=lt-0078ea8f7c4e4b68e

#ec2 instance creating
 aws ec2 describe-instances --filters Name=tag:Name,Values=${component}${{ENV}} | jq .Reservations[].Instances[].State.Name | sed 's/"//g' | grep -E 'run|stop' | jq
 if [ $? -ne 0 ]; then
    echo -e "\e[1;31m This instance is already there\e[0m"
  else
aws ec2 run-instances --launch-template LaunchTemplateId=${L_TEMPID} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${component}${{ENV}}}]" | jq
fi
 IPADDRESS=$(aws ec2 describe-instances --filter "Name=tag:Name,Values=${component}${{ENV}}" | jq .Reservations[].Instances[].PrivateIpAddress | sed 's/"//g' | grep -v null )

sleep 10

sed -e "s/IPADDRESS/${IPADDRESS}${{ENV}}/" -e "s/component/${component}${{ENV}}/" resource.json >/tmp/resource.json
aws route53 change-resource-record-sets --hosted-zone-id ${ID_ZONE} --change-batch file:///tmp/resource.json | jq

#updateing route53
}

# for instent creation of ec2 instances using loops function to create
if [ ${component} == "all" ]; then
   for ec2s in frontend${{ENV}} catalogue${{ENV}} rabbitmq${{ENV}};do
    component=${ec2s}
    CREATE_EC2
   done
  else
  CREATE_EC2
fi
