#!/bin/bash

echo "i am catalogue"



set -e
COMPONENT=catalogue
LOGFILE="/tmp/$COMPONENT.log"
APPUSER=roboshop



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

echo -n "CONFIGURING THE NODE-JS REPO :"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
stat $?

echo -n "INSTALLING NODE-JS :"
yum install nodejs -y &>> $LOGFILE
stat $?

echo -n "CREATING THE APPLICATION USER ACCOUNT:"
useradd $APPUSER
stat $?

echo -n "DOWNLOADING THE $COMPONENT :"
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
stat $?

echo -n "EXTRACTING THE $COMPONENT IN THE $APPUSER DIRECTORY :"
cd /home/roboshop
unzip -O /tmp/catalogue.zip &>> $LOGFILE
stat $?
# $ mv catalogue-main catalogue
# $ cd /home/roboshop/catalogue
# $ npm install
