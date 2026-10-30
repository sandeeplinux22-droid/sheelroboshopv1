#!/bin/bash

user_id=(id -u)
logs_folder=/var/log/shellscripting
logs_file="${logs_folder/{0}.log}"
domain_name="sandeeplinux22.store"
scripts_dir=$(dirname "$(realpath "$0")")

mkdir -p $logs_folder

valdiate (){
    if [ $1 -ne 0 ]; then
    echo "$user_id is present ignore the message"
    fi
}

dnf module enable maven:3.9 -y
dnf install maven java-25-openjdk-devel -y
valdiate $? "enable and install maven"

alternatives --config java
validate $? "once install keep alternative config"

echo "export JAVA_HOME=$(dirname $(dirname $(readlink -f /usr/bin/java)))" > /etc/profile.d/java.sh
source /etc/profile.d/java.sh
echo $JAVA_HOME

validate $? "java profile create"

java -version
mvn -v
validate $? "check java version"


useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
validate $? "create roboshop user"

rm -rf /app
validate $? "remove app directory"


mkdir /app
curl -L -o /tmp/shipping.zip https://raw.githubusercontent.com/daws-92s/roboshop-documentation/refs/heads/main/artifacts/shipping-v4.zip
validate $? "download the packages"


cd /app
unzip /tmp/shipping.zip
validate $? "unzip the file"

cd /app
mvn clean package
validate $? "clean the packages"

mv target/shipping.jar shipping.jar
validate $? "shipping jar"

sed -i "s/DOMAIN_NAME/$domain_name/g" "$scripts_dir/shipping.service"
cp "$scripts_dir/shipping.service" /etc/systemd/system/shipping.service

dnf install mysql -y
validate $? "install mysql"

count=$(mysql -h "mysql.$domain_name" -u root -pRoboShop@1 -N -B -e "SELECT COUNT(*) FROM cities.cities;" 2>> $logs_file )
if [ -z "$count" ] || [ "$count" -eq 0 ]; then
    mysql -h "mysql.$domain_name" -u root -pRoboShop@1 < /app/db/master-data.sql
    validate $? "Loading shipping data"
fi

mysql -h "mysql.$domain_name" -u root -pRoboShop@1 < /app/db/app-user.sql
validate $? "Creating APP user"


systemctl daemon-reload &>> $logs_file
systemctl enable shipping &>> $logs_file
systemctl restart shipping
validate $? "Restarting and Starting shipping"







