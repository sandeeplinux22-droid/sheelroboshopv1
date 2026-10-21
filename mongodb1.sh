#!/bin/bash

user_id=(id -u)
logs_folder="(/var/log/roboshop)"
logs_file="${logs_folder} / ${0}.log"

mkdir -p $logs_folder

id [ $user_id -ne 0 ]; then
 echo "please run the script without sudo access"
fi
echo "Script started execution at $(date +"%F %T")" &>> $logs_file
valiadate() {
    if [ $1 -ne 0 ]; then
        echo -e "${2}..${R}FAILED${N}" | tee -a $logs_file
        exit 1
    else
        echo -e "${2}..${G}SUCCESS${N}" | tee -a $logs_file
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo
validate $? "Adding mongo repo"

dnf install mongodb-org -y &>> $logs_file
validate $? "Install MongDB"

systemctl enable mongod &>> $logs_file
systemctl start mongod &>> $logs_file
validate $? "Enable and start MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
validate $? "Updating remote connections to MongoDB"

systemctl restart mongod
validate $? "Restarting MongoDB"