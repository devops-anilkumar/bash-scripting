

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

CREATE-USER() { 
    id $APPUSER &>> $LOGFILE
if [ $? -ne 0 ] ; then
        echo -n "CREATING THE APPLICATION USER ACCOUNT:" 
        useradd $APPUSER &>> $LOGFILE
        stat $?
fi
}



DOWNLOAD-AND-EXTRACT() {

echo -n "DOWNLOADING THE $COMPONENT :"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?

echo -n "EXTRACTING THE $COMPONENT IN THE $APPUSER DIRECTORY :"
cd /home/$APPUSER
rm -rf /home/$APPUSER/$COMPONENT  &>> $LOGFILE
unzip -o /tmp/$COMPONENT.zip   &>> $LOGFILE
stat $?

echo -n "CONFIGURINNG THE PERMISSIONS :"
mv /home/$APPUSER/$COMPONENT-main /home/$APPUSER/$COMPONENT
chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT
stat $?
}

NPM-INSTALL() {

echo -n "INSTALLING THE $COMPONENT APPLICATION :"
cd /home/$APPUSER/$COMPONENT/
npm install   &>> $LOGFILE
stat $?
}

CONFIG-SVC() {
echo -n "UPDATING SYSTEM FILE WITH DB DETAILS :"
sed -i -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service
mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
stat $?

echo -n "STARTING THE $COMPONENT SERVICE :"
systemctl daemon-reload
systemctl enable $COMPONENT   &>> $LOGFILE
systemctl restart $COMPONENT   &>> $LOGFILE
stat $?
}


NODEJS() {  
echo -n "CONFIGURING THE NODE-JS REPO :"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> $LOGFILE
stat $?

echo -n "INSTALLING NODE-JS :"
yum install nodejs -y &>> $LOGFILE
stat $?

#calling create-user function
CREATE-USER

#callind download-and-extract function
DOWNLOAD-AND-EXTRACT

#calling npm-install
NPM-INSTALL

#calling config-svc
CONFIG-SVC
}


