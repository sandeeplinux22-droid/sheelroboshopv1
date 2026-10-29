#!/bin/bash

user_id=$(id -u)

logs_folder=/var/log/shellscripting
logs_file=${logs_folder/${0}.log}"

mkdir -p "$logs_folder"

validate () {

     if [ $user_id -ne 0 ]; then
     echo="$user _id need to be success if id having access"
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


cd /app
validate $? "enter to app directory"

npm install
validate $? "install npmpackages"


systemctl daemon-reload
systemctl enable user
systemctl start user
validate $? "relaod daemon and start user"

systemctl status user
validate $? "check user status"

curl http://localhost:8080/health
valdiate $? "check the local host health"