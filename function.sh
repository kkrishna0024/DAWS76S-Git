#!/bin/bash

ID=$(id -u)

VALIDATE () {

    if [ $? -ne 0 ]
    then
        echo "error:: install mysql is failed"
        exit 1
    else 
        echo " mysql installed success"

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

VALIDATE


yum install git -y

VALIDATE