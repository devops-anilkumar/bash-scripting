#!/bin/bash


echo "i am rabbitmq"


COMPONENT=rabbitmq
source components/common.sh

echo -n "INSTALLING AND CONFIGURING DEPENDANCY :"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash               &>> $LOGFILE
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash      &>> $LOGFILE
stat $?

echo -n "INSTALLING $COMPONENT :"
yum install rabbitmq-server -y  &>> $LOGFILE
stat $?

echo -n "STARTING THE $COMPONENT :"
systemctl enable rabbitmq-server   &>> $LOGFILE
systemctl start rabbitmq-server     &>> $LOGFILE
stat $?
rabbitmqctl list_users | grep $APPUSER   &>>  $LOGFILE
if [ $? -ne 0 ] ; then
echo -n "CREATING $COMPONENT APPLICATION USER :"
rabbitmqctl add_user roboshop roboshop123  &>> $LOGFILE
stat $? 
fi
