ID=$(id -u)
TIMESTAMP=$(date +$F-$H-$M-$s)
LOGFILE="$0-$TIMESTAMP.log"  

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

yum install mysql -y >>$LOGFILE

VALIDATE $? "installing Mysql"


yum install git -y >>$LOGFILE

VALIDATE $? " intalling git"