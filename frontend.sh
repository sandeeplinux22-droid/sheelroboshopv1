#!/bin/bash

user_id=(id -u)
logs_folder=/var/log/shellscripting
logs_file="${logs_folder/{0}.log}"
domain_name="sandeeplinux22.store"
scripts_dir=$(dirname "$(realpath "$0")")

if [ $user_id -ne 0 ]; then
    echo "Please run this script with sudo access.."
    exit 1
fi

mkdir -p $logs_folder




dnf module disable nginx -y
dnf module enable nginx:1.26 -y
dnf install nginx -y

validate $? "install nginx"

systemctl enable nginx
systemctl start nginx

valdiate $? "enable and start nginx"

rm -rf /usr/share/nginx/html/*
validate $? "remove nginx"

curl -L -o /tmp/frontend.zip https://raw.githubusercontent.com/daws-92s/roboshop-documentation/refs/heads/main/artifacts/frontend-v4.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
validate $? "unzip folder"

nginx -t
systemctl restart nginx
validate $? "restart nginx"

systemctl status nginx
curl http://localhost/health
curl http://localhost/api/catalogue/health
tail -f /var/log/nginx/access.log
validate $? "check health check"

