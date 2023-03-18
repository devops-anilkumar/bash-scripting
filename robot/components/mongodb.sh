#!/bin/bash


echo "i am mongodb"


set -e
COMPONENT=mongodb
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

echo -n "CONFIGURING THE $COMPONENT REPO :"
 curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
 stat $? 

 echo -n "INSTALLING $COMPONENT :"
 yum install -y mongodb-org &>> $LOGFILE
 stat $?


echo -n "STARTING $COMPONENT:"
systemctl enable mongod &>> $LOGFILE
systemctl start mongod &>> $LOGFILE
stat $?

echo -n "UPLOADING THE $COMPONENT VISIBILITY: "
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat $?

echo -n "PERFORMING DAEMON-RELOAD :"
systemctl daemon-reload &>> $LOGFILE
systemctl restart mongod &>> $LOGFILE
stat $?
