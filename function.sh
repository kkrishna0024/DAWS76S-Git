#!/bin/bash

ID=$(id -u)
Date=$(date)
echo " scriptname $0  $(date)"

VALIDATE () {

    if [ $1 -ne 0 ]
    then
        echo "error:: $2 ... failed"
        exit 1
    else 
        echo " $2... success"

    fi
}

if [ $ID -ne 0 ]
then
    echo " Error : : this is not root user"
    exit 1
else 
    echo " you are root user"

fi

yum install mysql -y

VALIDATE $? "installing Mysql"


yum install git -y

VALIDATE $? " intalling git"