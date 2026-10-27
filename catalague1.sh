#!/bin/bash


logs_folder=/app

if [ $logs_folder -ne 0 ]; then
    echo "$logs_folder need to remove if available"
    exit 1
fi
validate $? "check $logs_folder is present"

mkdir /app
validate $? "create directory app"