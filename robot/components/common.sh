

# LOGFILE="/tmp/$COMPONENT.log"
# APPUSER=roboshop



# #validating weather the excuting  user is a root user or not
# ID=$(id -u)
# if [ "$ID" -ne 0 ] ; then
#   echo -e "\e[31m you should excute this script as root user or with sudo as prefix \e[0m"
#   exit 1
# fi 




# stat() {
# if [ $1 -eq 0 ] ;then 
#  echo -e "\e[32m success\e[0m" 
# else
#  echo -e "\e[31m failure\e[0m" 
#  exit2
# fi 
# }

# CREATE_USER() { 
#     id $APPUSER &>> $LOGFILE
# if [ $? -ne 0 ] ; then
#         echo -n "CREATING THE APPLICATION USER ACCOUNT:" 
#         useradd $APPUSER &>> $LOGFILE
#         stat $?
# fi
# }



# DOWNLOAD_AND_EXTRACT() {

# echo -n "DOWNLOADING THE $COMPONENT :"
# curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
# stat $?

# echo -n "EXTRACTING THE $COMPONENT IN THE $APPUSER DIRECTORY :"
# cd /home/$APPUSER
# rm -rf /home/$APPUSER/$COMPONENT  &>> $LOGFILE
# unzip -o /tmp/$COMPONENT.zip   &>> $LOGFILE
# stat $?

# echo -n "CONFIGURINNG THE PERMISSIONS :"
# mv /home/$APPUSER/$COMPONENT-main /home/$APPUSER/$COMPONENT
# chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT
# stat $?
# }

# NPM_INSTALL() {

# echo -n "INSTALLING THE $COMPONENT APPLICATION :"
# cd /home/$APPUSER/$COMPONENT/
# npm install   &>> $LOGFILE
# stat $?
# }

# CONFIG_SVC() {
# echo -n "UPDATING SYSTEM FILE WITH DB DETAILS :"
# sed -i -e 's/DBHOST/mysql.roboshop.internal/' -e's/CARTENDPOINT/cart.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service
# mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
# stat $?

# echo -n "STARTING THE $COMPONENT SERVICE :"
# systemctl daemon-reload
# systemctl enable $COMPONENT   &>> $LOGFILE
# systemctl restart $COMPONENT   &>> $LOGFILE
# stat $?
# }

# MVN_PACKAGE() {
#     echo -n " CREATING THE $COMPONENT PACKAGE :"
#     cd /home/$APPUSER/$COMPONENT/
#     mvn clean package &>> $LOGFILE
#     mv target/shipping-1.0.jar shipping.jar
#     stat $?
# }




# JAVA() {
# echo -n "INSTALLING MAVEN  :" 
# yum install maven -y  &>> $LOGFILE
# stat $?

# #calling create-user function
# CREATE_USER

# #calling download-and-extract function
# DOWNLOAD_AND_EXTRACT

# #calling maven-package function
# MVN_PACKAGE

# #calling config-svc
# CONFIG_SVC

# }


# NODEJS() {  
# echo -n "CONFIGURING THE NODE-JS REPO :"
# curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> $LOGFILE
# stat $?

# echo -n "INSTALLING NODE-JS :"
# yum install nodejs -y &>> $LOGFILE
# stat $?
 
# #calling create-user function
# CREATE_USER

# #calling download-and-extract function
# DOWNLOAD_AND_EXTRACT

# #calling npm-install
# NPM_INSTALL

# #calling config-svc
# CONFIG_SVC

# }












LOGFILE="/tmp/$COMPONENT.log"
APPUSER=roboshop

# Validting whether the executed user is a root user or not 
ID=$(id -u)

if [ "$ID" -ne 0 ] ; then 
    echo -e "\e[31m You should execute this script as a root user or with a sudo as prefix \e[0m" 
    exit 1
fi 


stat() {
    if [ $1 -eq 0 ] ; then 
        echo -e "\e[32m Success \e[0m"
    else 
        echo -e "\e[31m Failure \e[0m"
        exit 2
    fi 
}

CREATE_USER() {

    id $APPUSER  &>> $LOGFILE
    if [ $? -ne 0 ] ; then 
        echo -n "Creating the Application User Account :" 
        useradd roboshop &>> $LOGFILE
        stat $? 
    fi 

}

DOWNLOAD_AND_EXTRACT() {

    echo -n "Downloading the $COMPONENT component :"
    curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
    stat $? 

    echo -n "Extracting the $COMPONENT in the $APPUSER directory"
    cd /home/$APPUSER 
    rm -rf /home/$APPUSER/$COMPONENT &>> $LOGFILE
    unzip -o /tmp/$COMPONENT.zip  &>> $LOGFILE
    stat $? 

    echo -n "Configuring the permissions :"
    mv /home/$APPUSER/$COMPONENT-main /home/$APPUSER/$COMPONENT
    chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT
    stat $?

}

NPM_INSTALL() {

    echo -n "Installing the $COMPONENT Application :"
    cd /home/$APPUSER/$COMPONENT/ 
    npm install &>> $LOGFILE
    stat $? 

}

CONFIG_SVC() {

    echo -n "Updating the systemd file with DB Details :"
    sed -i -e 's/AMQPHOST/rabbitmq.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/'  -e  's/CARTHOST/cart.roboshop.internal/' -e  's/DBHOST/mysql.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service
    mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
    stat $? 

    echo -n "Starting the $COMPONENT service : "
    systemctl daemon-reload &>> $LOGFILE
    systemctl enable $COMPONENT &>> $LOGFILE
    systemctl restart $COMPONENT &>> $LOGFILE
    stat $?

}

MVN_PACKAGE() {
    echo -n "Creating the $COMPONENT Package :"
    cd /home/$APPUSER/$COMPONENT/ 
    mvn clean package  &>> $LOGFILE
    mv target/shipping-1.0.jar shipping.jar
    stat $?   
}

PYTHON() {
    echo -n "Installing Python and dependencies :"
    yum install python36 gcc python3-devel -y  &>> $LOGFILE
    stat $?

    # Calling Create-User Functon 
    CREATE_USER

    # Calling Download_And_Extract Function
    DOWNLOAD_AND_EXTRACT

    echo -n "Installing $COMPONENT :"
    cd /home/roboshop/$COMPONENT/ 
    pip3 install -r requirements.txt   &>> $LOGFILE 
    stat $? 

    USERID=$(id -u roboshop)
    GROUPID=$(id -g roboshop)
    
    echo -n "Updating the $COMPONENT.ini file :"
    sed -i -e "/^uid/ c uid=${USERID}" -e "/^gid/ c gid=${GROUPID}"  /home/$APPUSER/$COMPONENT/$COMPONENT.ini 

    # Calling Config-Svc Function
    CONFIG_SVC

}

JAVA() {
    echo -n "Installing Maven  :" 
    yum install maven -y &>> $LOGFILE
    stat $?

    # Calling Create-User Functon 
    CREATE_USER

    # Calling Download_And_Extract Function
    DOWNLOAD_AND_EXTRACT

    # Calling Maven Package Functon
    MVN_PACKAGE

    # Calling Config-Svc Function
    CONFIG_SVC

}






NODEJS() {

    echo -n "Configuring the nodejs repo :"
    curl --silent --location https://rpm.nodesource.com/setup_16.x | bash - &>> $LOGFILE
    stat $?  

    echo -n "Installing NodeJS :"
    yum install nodejs -y &>> $LOGFILE
    stat $?

    # Calling Create-User Functon 
    CREATE_USER

    # Calling Download_And_Extract Function
    DOWNLOAD_AND_EXTRACT

    # Calling NPM Install Function
    NPM_INSTALL

    # Calling Config-Svc Function
    CONFIG_SVC

}
