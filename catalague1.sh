#!/bin/bash


logs_folder=/app

validate () {



if [ ${logs_folder} -ne 0 ]; then
    echo "$logs_folder need to remove if available"
    exit 1
fi

}

mkdir /app
validate $? "create directory app"