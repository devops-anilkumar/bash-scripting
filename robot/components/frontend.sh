#!/bin/bash

echo "i am frontend"

#set -e
COMPONENT=frontend
LOGFILE="/tmp/$COMPONENT.log


#validating weather the excuting  user is a root user or not
ID=$(id -u)
if [ "$ID" -ne 0 ] ; then
            echo -e "\e[31m you should excute this script as root user or with sudo as prefix \e[0m"
            exit 1
fi 
yum install nginx -y     &>>$LOGFILE
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"





cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf


systemctl enable nginx
systemctl restart nginx