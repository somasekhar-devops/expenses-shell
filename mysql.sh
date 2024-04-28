#!/bin/bash

Timestamp=$(date +%F-%H-%M-%S)
Script_Name=$(echo $0 | cut -d "." -f1)
Logfile=/tmp/$Script_Name-$Timestamp.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USERROLE=$(id -u)

if [ $USERROLE -ne 0 ]
then
    echo "You are not a Super User. Get the Super access from admin."
    exit 1
else
    echo "You are a Super User.. Go ahead"
fi

Validate(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 $R Failure $N"
        exit 1
    else
        echo -e "$2 $G Success $N"
    fi
}

dnf install mysql-server -y &>>$Logfile
Validate $? "Installing mysql server"

systemctl enable mysqld &>>$Logfile
Validate $? "Enabling mysql server"

systemctl start mysqld &>>$Logfile
Validate $? "Starting mysql server"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$Logfile
Validate $? "Setting up the root password for mysql server"