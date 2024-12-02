#!/bin/bash/

AMI=ami-0b4f379183e5706b9
SG_ID=sg-05ea3dc55b6da7ad6
instances=("Mangodb" "mysql" "redis" "user" "cart" "web" "shipping" "payments" "dispatch" "rabitmq" "catalogue")

for i in "${instances [@]}"

echo "instance is : $i"
 do 
  if [$i= "Mangodb"] || [$i= "mysql"] || [$i= "redis"]
  then 
   instance_type=t3.small

   else 
   instance_type=t2.micro
  fi

   IP_ADDRESS=$(aws ec2 run-instances --image-id ami-0b4f379183e5706b9 --count 1 --instance-type $instance_type  --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query "Instances[0].PrivateIpAddress"  --output text)
   echo "instance is : $i $IP_ADDRESS"
 done

