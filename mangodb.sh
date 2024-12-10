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

cp mongo.repo /etc/yum.repos.d/ &>>$LOGFILE
VALIDATE $? " copied mangoDB repo"

dnf install mongodb-org -y &>>$LOGFILE
VALIDATE $? " imstalled mangoDB"

systemctl enable mongod
VALIDATE $? " enabled mangoDB"

systemctl start mongod
VALIDATE $? " starting mangoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf

VALIDATE $? " replaced host details for remote access"

systemctl restart mongod

VALIDATE $? " restarting mangoDB"
