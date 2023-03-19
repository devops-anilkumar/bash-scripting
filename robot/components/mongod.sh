#!/bin/bash
echo "i am mongodb"

set -e

COMPONENT=mongodb
LOGFILE="/tmp/$COMPONENT.log"
# giving root previlages to the user

ID=$(id -u)
if [ "$ID" -ne 0 ] ; then
    echo -e "\e[31m you should excute this script as a root user or with sudo as a prefix \e[0m"
    exit 1
fi


stat() {
if [ $1 -eq 0 ] ; then
     echo -e "\e[32m success \e[0m"
else
     echo -e "\e[31m failure \e[0m"
     exit 2
fi
}


echo -n "CONFIGURING THE $COMPONENT REPO :"
curl -s -o /etc/yum.repos.d/$COMPONENT.repo https://raw.githubusercontent.com/stans-robot-project/$COMPONENT/main/mongo.repo
stat $?

echo -n " INSTALLING $COMPONENT :"
yum install -y mongodb-org &>> $LOGFILE
stat $?

echo -n "STARTING $COMPONENT:"
systemctl enable mongod &>> $LOGFILE
systemctl start mongod  &>> $LOGFILE
stat $?

echo -n "UPDATING $COMPONENT VISIBILITY