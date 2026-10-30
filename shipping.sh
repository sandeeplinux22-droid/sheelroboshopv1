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
#validate $? "once install keep alternative config"

echo "export JAVA_HOME=$(dirname $(dirname $(readlink -f /usr/bin/java)))" > /etc/profile.d/java.sh
source /etc/profile.d/java.sh
echo $JAVA_HOME

validate $? "java profile create"

java -version
mvn -v

validate $? "check java version"


useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
validate $? "create roboshop user"




