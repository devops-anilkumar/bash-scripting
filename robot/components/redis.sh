#!/bin/bash

echo "i am redis"


set -e
COMPONENT=redis
LOGFILE="/tmp/$COMPONENT.log"



#validating weather the excuting  user is a root user or not
ID=$(id -u)
if [ "$ID" -ne 0 ] ; then
  echo -e "\e[31m you should excute this script as root user or with sudo as prefix \e[0m"
  exit 1
fi 
stat() {
if [ $1 -eq 0 ] ;then 
 echo -e "\e[32m success\e[0m" 
else
 echo -e "\e[31m failure\e[0m" 
 exit2
fi 
}

echo -n "CONFIGURING $COMPONENT REPO:"
curl -L https://raw.githubusercontent.com/stans-robot-project/$COMPONENT/main/$COMPONENT.repo -o /etc/yum.repos.d/$COMPONENT.repo
stat $?

echo -n "INSTALLING $COMPONENT SERVER :"
yum install redis-6.2.11 -y  &>> $LOGFILE
stat $?

echo -n "UPDATING $COMPONENT VISIBILITY:"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
stat $?

echo -n "PERFORMING DAEMON-RELOAD:"
systemctl daemon-reload   &>> $LOGFILE
systemctl restart $COMPONENT
stat $?
