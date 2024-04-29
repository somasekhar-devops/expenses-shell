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

dnf install nginx -y &>>$Logfile
Validate $? "Installing nginx"

systemctl enable nginx &>>$Logfile
Validate $? "Enabling nginx"

systemctl start nginx &>>$Logfile
Validate $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>>$Logfile
Validate $? "Removing existing files from the directory"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$Logfile
Validate $? "Downloading the fronend application"

cd /usr/share/nginx/html &>>$Logfile
Validate $? "Moving to nginx directory"

unzip /tmp/frontend.zip &>>$Logfile
Validate $? "Extracting the frontend code"

cp /home/ec2-user/expenses-shell/frontend.conf /etc/nginx/default.d/expense.conf &>>$Logfile
Validate $? "Copying frontend config file"

systemctl restart nginx &>>$Logfile
Validate $? "Restarting nginx"
