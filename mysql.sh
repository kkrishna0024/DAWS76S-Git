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

dnf module disable mysql -y  &>>$LOGFILE

VALIDATE $? "mysql module disabled" 

cp /root/DAWS76S-Git/mysql.repo /etc/yum.repos.d/mysql.repo &>>$LOGFILE

VALIDATE $? "mysql repo file copied"

dnf install mysql-community-server -y &>>$LOGFILE

VALIDATE $? "mysql community server installed"

systemctl enable mysqld &>>$LOGFILE

VALIDATE $? "mysqld enabled"

systemctl start mysqld &>>$LOGFILE

VALIDATE $? "mysqld started"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOGFILE

VALIDATE $? "root password set"
mysql -uroot -pRoboShop@1 &>>$LOGFILE

VALIDATE $? "root password working"


