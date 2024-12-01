#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"  
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

VALIDATE () {

    if [ $1 -ne 0 ]
    then
        echo -e "error:: $2 ... $R failed$N"
        exit 1
    else 
        echo -e " $2... $G success$N"

    fi
}

if [ $ID -ne 0 ]
then
    echo -e " Error : :$R this is not root user$N"
    exit 1
else 
    echo  " you are root user"
fi

for package in $@
 do 
  yum list installed $package  &>>$LOGFILE

  if [ $? -ne 0 ]
   then 
     yum install $package -y &>>LOGFILE
     VALIDATE $? "installed $package"
    else 

       echo -e "$package already installed $Y Skipping$N"
  fi

done

dnf install nginx -y &>>$LOGFILE

VALIDATE $? "installed nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "enabled nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "started nginx" 

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "removed default nginx html"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$LOGFILE
VALIDATE $? "downloaded web application"

cd /usr/share/nginx/html
unzip  -o /tmp/web.zip &>>$LOGFILE

VALIDATE $? "unzipped web application" 


cp  /root/DAWS76S-Git/roboshop.conf  /etc/nginx/default.d/roboshop.conf &>>$LOGFILE
VALIDATE $? "copied reversprocy "

systemctl restart nginx &>>$LOGFILE

VALIDATE $? "restarted nginx" 