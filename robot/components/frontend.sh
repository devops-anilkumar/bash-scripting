#!/bin/bash

echo "i am frontend"

set -e
COMPONENT=frontend
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

echo -n "INSTALLING NGINX:"
yum install nginx -y     &>> $LOGFILE
stat $?



echo -n "DOWNLOADING THE $COMPONENT component:"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?



echo -n "PERFORMING CLEANUP OF OLD CONTENT:"
cd /usr/share/nginx/html
rm -rf *   &>> $LOGFILE
stat $?


echo -n "COPYING THE DOWNLOADED $COMPONENT CONTENT:"
unzip /tmp/frontend.zip   &>> $LOGFILE
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "STARTING THE SERVICE:"
systemctl enable nginx  &>> $LOGFILE
systemctl restart nginx &>> $LOGFILE
stat $?