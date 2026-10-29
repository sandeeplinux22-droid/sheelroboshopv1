#!/bin/bash

user_id=$(id -u)

logs_folder=/var/log/shellscripting
logs_file=${logs_folder/${0}.log}"

mkdir -p "$logs_folder"

validate () {

     if [ $user_id -ne 0 ]; then
     echo="user_id need to be success if id having access"
     fi
}

dnf module disable nodejs -y
dnf module enable nodejs:24 -y
dnf install nodejs -y
validate $? "need to disable enable and insatll nodejs"

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
validate $? "create user"

rm -rf /app
validate $? "remove old file"

mkdir -p /app
validate $? "create app directory "
curl -L -o /tmp/user.zip https://raw.githubusercontent.com/daws-92s/roboshop-documentation/refs/heads/main/artifacts/user-v4.zip
valdiate $? "please unzip file"

cd /app
validate $? "enter to app directory"


unzip /tmp/user.zip
validate $? "unzip the file"



cd /app
validate $? "enter to app directory"

npm install
validate $? "install npmpackages"


systemctl daemon-reload
systemctl enable user
systemctl start user
validate $? "relaod daemon and start user"



