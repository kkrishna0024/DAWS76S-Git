#!/bin/bash

ID=$(id -u)

if [ $ID -ne 0 ]
then
    echo " Error : : this is not root user"
    exit 1
else 
    echo " you are root user"

fi

yum install mysql -y

if [ $? -ne 0 ]
then
    echo "error:: install mysql is failed"
    exit 1
else 
    echo " mysql installed success"

fi

yum install git -y

if [ $? -ne 0 ]
then
    echo "error:: install git is failed"
    exit 1
else 
    echo " mysql git success"

fi