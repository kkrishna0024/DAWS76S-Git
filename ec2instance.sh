#!/bin/bash/

AMI=ami-0b4f379183e5706b9
SG_ID=sg-05ea3dc55b6da7ad6
Instances=("Mangodb" "mysql" "redis" "user" "cart" "web" "shipping" "payments" "dispatch" "rabitmq" "catalogue")

for i in "${INSTANCES[@]}"
do 
  if [ $i == "Mangodb" ] || [$i== "mysql" ] || [ $i== "redis" ]
  then 
   INSTANCE_TYPE=t3.small

   else 
   INSTANCE_TYPE=t2.micro
  fi

   IP_ADDRESS=$(aws ec2 run-instances --image-id ami-0b4f379183e5706b9 --instance-type $INSTANCE_TYPE  --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress'  --output text)
   echo "$i: $IP_ADDRESS"

    aws route53 change-resource-record-sets \
    --hosted-zone-id Z03864262OMVQMXMFTVWQ \
    --change-batch "
   {
     "Comment": "Testing creating a record set"
     ,"Changes": [{
      "Action"              : "CREATE"
      ,"ResourceRecordSet"  : {
        "Name"              : "$i .prasuna.site"
        ,"Type"             : "A"
        ,"TTL"              : 1
        ,"ResourceRecords"  : [{
            "Value"         : "$IP_ADDRESS"
        }]
      }
      }]
     }
     "
 done

 