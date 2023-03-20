

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

CREATE_USER() { 
    id $APPUSER &>> $LOGFILE
if [ $? -ne 0 ] ; then
        echo -n "CREATING THE APPLICATION USER ACCOUNT:" 
        useradd $APPUSER &>> $LOGFILE
        stat $?
fi
}



DOWNLOAD_AND_EXTRACT() {

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

NPM_INSTALL() {

echo -n "INSTALLING THE $COMPONENT APPLICATION :"
cd /home/$APPUSER/$COMPONENT/
npm install   &>> $LOGFILE
stat $?
}

CONFIG_SVC() {
echo -n "UPDATING SYSTEM FILE WITH DB DETAILS :"
sed -i -e 's/DBHOST/mysql.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service
sed -i -e's/CARTENDPOINT/172.31.63.152/' /home/$APPUSER/$COMPONENT/systemd.service
sed -i -e 's/CATALOGUE_ENDPOINT/172.31.11.24/' /home/$APPUSER/$COMPONENT/systemd.service
sed -i -e 's/REDIS_ENDPOINT/172.31.59.246/' /home/$APPUSER/$COMPONENT/systemd.service
sed -i -e 's/MONGO_ENDPOINT/172.31.8.106/' /home/$APPUSER/$COMPONENT/systemd.service
mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
stat $?

echo -n "STARTING THE $COMPONENT SERVICE :"
systemctl daemon-reload
systemctl enable $COMPONENT   &>> $LOGFILE
systemctl restart $COMPONENT   &>> $LOGFILE
stat $?
}

MVN_PACKAGE() {
    echo -n " CREATING THE $COMPONENT PACKAGE :"
    cd /home/$APPUSER/$COMPONENT/
    mvn clean package &>> $LOGFILE
    mv target/shipping-1.0.jar shipping.jar
    stat $?
}




JAVA() {
echo -n "INSTALLING MAVEN  :" 
yum install maven -y  &>> $LOGFILE
stat $?

#calling create-user function
CREATE_USER

#calling download-and-extract function
DOWNLOAD_AND_EXTRACT

#calling maven-package function
MVN_PACKAGE

#calling config-svc
CONFIG_SVC

}


NODEJS() {  
echo -n "CONFIGURING THE NODE-JS REPO :"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> $LOGFILE
stat $?

echo -n "INSTALLING NODE-JS :"
yum install nodejs -y &>> $LOGFILE
stat $?
 
#calling create-user function
CREATE_USER

#calling download-and-extract function
DOWNLOAD_AND_EXTRACT

#calling npm-install
NPM_INSTALL

#calling config-svc
CONFIG_SVC

}


