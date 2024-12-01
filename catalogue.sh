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

dnf module disable nodejs -y &>>LOGFILE
dnf module enable nodejs:18 -y &>>LOGFILE

VALIDATE $? "enabled nodejs18"

dnf install nodejs -y &>>LOGFILE

VALIDATE $? "installed nodejs"

useradd roboshop  &>>LOGFILE

mkdir /app  &>>LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip  &>>LOGFILE
cd /app 
unzip /tmp/catalogue.zip  &>>LOGFILE
VALIDATE $? "unzipped catalogue"
cd /app 
npm install   &>>LOGFILE
VALIDATE $? "libraries intalled"

systemctl daemon-reload  &>>LOGFILE
VALIDATE $? "reloaded daemon"

systemctl enable catalogue  &>>LOGFILE
VALIDATE $? "enabled cataloge"

systemctl start catalogue  &>>LOGFILE
VALIDATE $? "started catalogue"

dnf install mongodb-org-shell -y  &>>LOGFILE
VALIDATE $? "installed mango db"

mongo --host 172.31.38.133 </app/schema/catalogue.js  &>>LOGFILE
VALIDATE $? "loaded schema"