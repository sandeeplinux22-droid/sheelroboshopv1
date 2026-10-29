#!/bin/bash

user_id=(id -u)
logs_folder=/var/log/shellscripting
logs_file="${logs_folder/{0}.log}"
domain_name="sandeeplinux22.store"
scripts_dir=$(dirname "$(realpath "$0")")

mkdir -p $logs_folder

validate (){
   if [ $1 -ne 0 ]; then
   echo "$user_id is having root access"
   exit 1 
fi 
}

dnf module disable nodejs -y
dnf module enable nodejs:24 -y
dnf install nodejs -y
validate $? "disable and install nodejs"

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
validate $? "create user"

rm -rf /app
validate $? "remove app directory"

mkdir /app
validate $? "packages download"
curl -L -o /tmp/cart.zip https://raw.githubusercontent.com/daws-92s/roboshop-documentation/refs/heads/main/artifacts/cart-v4.zip
validate $? "packages download"
cd /app
unzip /tmp/cart.zip
validate $? "packages download"

cd /app
npm install
validate $? "install packages"

sed -i "s/DOMAIN_NAME/$domain_name/g" "$scripts_dir/cart.service"
cp "$scripts_dir/cart.service" /etc/systemd/system/cart.service

systemctl daemon-reload
systemctl enable cart
systemctl start cart

validate $? "reload and start the cart"





