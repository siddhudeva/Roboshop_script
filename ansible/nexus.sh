#!/bin/bash
  #author : siddhu
  #Date : 05-01-2022
  # This file is used to install Nexus repository in Linux operating system..(Centos)

  Log=/tmp/sonar.log


  yum update -y &>>${Log}
  echo -e "\e[1;32m Local updation\e[0m"

  yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel &>>${Log}
  echo -e "\e[1;32mJava installation is success\e[0m"

  curl -s -L -o /opt https://download.sonatype.com/nexus/3/latest-unix.tar.gz &>>${Log}
  echo -e "\e[1;32m sonarnexus file downloaded\e[0m"

  cd /opt && tar -xvzf latest-unix.tar.gz &>>${Log} && mv nexus-3.37.3-02 nexus 2>>${Log} && mv sonatype-work nexusdata 2>>${Log}

  echo -e "\e[1;31m unzipping content\e[0m"

  cat /etc/passwd | grep nexus &>>${Log}
   if [ $? -ne 0 ]; then
  useradd --system --no-create-home nexus
  chown -R nexus:nexus /opt/nexus && chown -R nexus:nexus /opt/nexusdata
  echo -e "\e[1;32m adding nexus user\e[0m"
  echo -e "\e[1;32m adding userpermission to the Files\e[0m"
  else
   echo -e "\e[1;32m nexus user is already there\e[0m"
   exit
  fi
  sed -e -i '/Dkaraf.data/ s/sonatype-work/nexus/g' -e '/Dkaraf.log/ s/sonatype-work/nexus/g' -e '/Djava.io.tmpdir/ s/sonatype-work/nexus/g' /opt/nexus/bin/nexus.vmoptions &>>${Log}
   echo -e "\e[1;32mnexus.vmoptions file is updated\e[0m"

  sed -i 's/""/"nexus"/' nexus.rc &>>${Log}
   echo -e "\e[1;32mnexus.rc file is updated\e[0m"

  sed -i -e   's/0.0.0.0/127.0.0.1/' /opt/nexus/etc/nexus-default.properties &>>${Log}
   echo -e "\e[1;32mnexus-default file is updated\e[0m"
  mkdir -p /opt/nexus/etc/security
  echo 'nexus - nofile 65536' >>/opt/nexus/etc/security/limits.conf
   echo -e "\e[1;32mlimits.conf file is updated\e[0m"

  echo '[Unit]
   Description=Nexus Service
   After=syslog.target network.target

   [Service]
   Type=forking
   LimitNOFILE=65536
   ExecStart=/opt/nexus/bin/nexus start
   ExecStop=/opt/nexus/bin/nexus stop
   User=nexus
   Group=nexus
   Restart=on-failure

   [Install]
   WantedBy=multi-user.target' >/etc/systemd/system/nexus.service
  echo -e "\e[1;32m nexus.service file is created\e[0m"

  systemctl daemon-reload && systemctl start nexus.service && systemctl enable nexus.service &>>${Log}
   echo -e "\e[1;32mnexus service is started and enabled\e[0m"
