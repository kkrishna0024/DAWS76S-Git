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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGFILE

VALIDATE $? "installed remi release 8"

dnf module enable redis:remi-6.2 -y &>>$LOGFILE

VALIDATE $? "module enabled remi -6.2"

dnf install redis -y &>>$LOGFILE

VALIDATE $? "installed redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf &>>$LOGFILE

VALIDATE $? " replaced host details for remote access"

systemctl enable redis &>>$LOGFILE

VALIDATE $? " enable redis"

systemctl start redis &>>$LOGFILE

VALIDATE $? " started redis"
