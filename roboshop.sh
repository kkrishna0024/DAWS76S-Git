#!/bin/bash/

AMI=ami-0b4f379183e5706b9
SG_ID=sg-05ea3dc55b6da7ad6
Zone_ID=Z03864262OMVQMXMFTVWQ
Domain_ID=prasuna.site
INSTANCES=("Mangodb" "mysql" "redis" "user" "cart" "web" "shipping" "payments" "dispatch" "rabitmq" "catalogue")

for i in "${INSTANCES[@]}"
do 
  if [ "$i" == "Mangodb" ] || [ "$i" == "mysql" ] || [ "$i" == "redis" ]
  then 
   INSTANCE_TYPE=t3.small

   else 
   INSTANCE_TYPE=t2.micro
  fi

   IP_ADDRESS=$(aws ec2 run-instances --image-id ami-0b4f379183e5706b9 --count 1 --instance-type $INSTANCE_TYPE  --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress'  --output text)
   echo "$i , $IP_ADDRESS"
  aws route53 change-resource-record-sets \
  --hosted-zone-id $Zone_ID \
  --change-batch '
  {
    "Comment": "Creating a record set for cognito endpoint"
    ,"Changes": [{
      "Action"              : "UPSERT"
      ,"ResourceRecordSet"  : {
        "Name"              : "'$i'.'$Domain_ID'"
        ,"Type"             : "A"
        ,"TTL"              : 1
        ,"ResourceRecords"  : [{
            "Value"         : "'$IP_ADDRESS'"
        }]
      }
    }]
  }'
   
 done

 