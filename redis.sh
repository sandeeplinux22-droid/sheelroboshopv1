#!/bin/bash

user_id=[id -u]
logs_file=/var/log/shellscripting/
logs_folder=${logs_file/${0}.log}

mkdir -p $logs_folder

echo "Script started execution at $(date +"%F %T")" &>> $logs_file

validate(){
    if [ $1 -ne 0 ]; then
        echo -e "${2}..${R}FAILED${N}" | tee -a $logs_file
        exit 1
    else
        echo -e "${2}..${G}SUCCESS${N}" | tee -a $logs_file
    fi

}

cp -p /etc/redis/redis.conf /etc/redis/redis.conf_bkp

dnf module disable redis -y
dnf module enable redis:7 -y
dnf install redis -y

validate $? "enable and install redis"

sed -i -e 's/^bind 127.0.0.1/bind 0.0.0.0/' -e 's/^protected-mode yes/protected-mode no/' /etc/redis/redis.conf
validate $? "replace mode"

systemctl enable redis
systemctl start redis

validate $? "enable and start redis"

systemctl status redis

validate $? "check status redis"

ss -lntp | grep 6379
validate $? "check port status"

redis-cli ping
validate $? "ping the redis-cli"

