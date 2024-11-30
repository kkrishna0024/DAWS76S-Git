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
    echo -e " Error : :$R this is not root user"
    exit 1
else 
    echo -e " $G you are root user"
fi

echo " all arguments passed $@"

for package in $@
 do 
  yum list installed $package 

  if [$? -ne 0]
   then 
     yum install $package -y &>>LOGFILE
     VALIDATE $? "installed  $package $G success"
    else 

       echo "instlled $package $Y already installed"
  fi

done

   