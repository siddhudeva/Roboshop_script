USER=$(id -u)
if [ "$USER" -ne 0 ]; then
   echo -e "\e[1;31m You are not a authorised person to run this\e[0m"
   exit
fi

LOG=/tmp/ansible.log
rm -rf /tmp/ansible.log

#validating tag mantioned or not
   component=${1}
if [ -z ${component} ]; then
   echo -e "\e[1;31mPlease enter a tag name so that we can add a instance\e[0m"
 exit
fi

EC() {
component=$1

aws ec2 describe-instances --filter "Name=tag:Name,Values=${component}" | jq .Reservations[].Instances[].State.Name | sed -s 's/"//g' | grep -E 'run|stop' &>>/dev/null
 if [ $? -eq 0 ];then
   echo -e "\e[1;31mThis instamce is already there\e[0m"
  else
    aws ec2 run-instances \
        --launch-template LaunchTemplateId=lt-0078ea8f7c4e4b68e \
        --tag-specifications "ResourceType=instance,Tags=[{Key=name,Values=${component}}]" &>>${LOG}
           if [ $? -ne 0 ];then
             echo -e "\e[1;32m${component} creation is -failure\e[0m"
              else
             echo -e "\e[1;32m${component} creation is -success\e[0m"
             exit
           fi
 fi
}




