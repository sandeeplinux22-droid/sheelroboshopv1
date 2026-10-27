#!/bin/bash

user_id=$(id -u)
logs_file=/var/log/shellscripting
logs_folder=${logs_file/${0}.log}

validate (){
    if [ $user_id -ne 0 ]; then
    echo "$user_id need to sucess if user having root access"
    exit 1
    fi
}

mkdir -p $logs_folder

dnf module enable mysql:8.4 -y
dnf install mysql-server -y

validate $? "enable and install the mysql server"

systemctl enable mysqld
systemctl start mysqld

validate $? "enable and start mysqld"

mysql_secure_installation --set-root-pass RoboShop@1
validate $? "keep user name"

