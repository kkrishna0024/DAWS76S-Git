#!/bin/bash

DISK_USAGE=$(df -hT | grep -vE 'tmp|File')
DISK_THRESHOULD=1
message=""

while IFS= read line
do
   usage=$(echo $line | awk '{print $6F}' | cut -d % -f1)
   partition=$(echo $line | awk '{print $1F}')

   if [$usage -gt $DISK_THRESHOULD]
    then 
    message+= " Hidisk usage on $partition: $usage"
    fi
done <<< $DISK_USAGE

echo -e "Message: $message"

echo -e "$message" | mail -s "message" info@devops.com

sh mail.sh "DevOps Team" "High Disk Usage" "$message" "info@devops.com" "Disk Usage"