ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"  
R="\e[31m"
G="\e[32m"
N="\e[37m"
Y="\e[33m"
VALIDATE () {

    if [ $1 -ne 0 ]
    then
        echo "error:: $2 ... $R failed $N"
        exit 1
    else 
        echo " $2... $G success $N"

    fi
}

if [ $ID -ne 0 ]
then
    echo " Error : : this is not root user"
    exit 1
else 
    echo " you are root user"

fi

yum install mysql -y &>>$LOGFILE

VALIDATE $? "installing Mysql"


yum install git -y &>>$LOGFILE

VALIDATE $? " intalling git"