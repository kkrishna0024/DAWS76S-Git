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
id roboshop
 if [ $? -ne 0 ]
 then 
 useradd roboshop  &>>LOGFILE
 else 
      echo -e "roboshop user already exist $Y skipping $N"
fi
VALIDATE $? "robohop user created"

mkdir -p /app  &>>LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip  &>>LOGFILE
cd /app 

unzip -o /tmp/catalogue.zip  &>>LOGFILE
VALIDATE $? "unzipped catalogue"

cd /app 
npm install   &>>LOGFILE
VALIDATE $? "libraries intalled"

cp  /root/DAWS76S-Git/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "copiued catalogue services file"

systemctl daemon-reload  &>>LOGFILE
VALIDATE $? "reloaded daemon"

systemctl enable catalogue  &>>LOGFILE
VALIDATE $? "enabled cataloge"

systemctl start catalogue  &>>LOGFILE
VALIDATE $? "started catalogue"

cp /root/DAWS76S-Git/mongo.repo /etc/yum.repos.d/mongo.repo

dnf install mongodb-org-shell -y  &>>LOGFILE
VALIDATE $? "installed mango db"

mongo --host 172.31.38.133 </app/schema/catalogue.js  &>>LOGFILE
VALIDATE $? "loaded schema"