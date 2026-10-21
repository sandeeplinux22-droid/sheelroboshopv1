#!/bin/bash

ami_id="ami-0055977a6e828a4f4"
instance_type="t3.micro"
domain_id="sandeeplinux22.store"
hosted_zone_id="Z09842261W8MW372F9VFX"


for instance in $@
do
   echo "creating instance: $instance"

   instance_id=$(aws ec2 run-instances \
    --image-id ami-0220d79f3f480ecf5 \
    --instance-type t3.micro \
    --security-groups "roboshop-common" \
	--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=roboshop-shell}]' \
	--query 'Instances[0].InstanceId' \
    --output text
    
   )

    echo "$instance ID: $instance_id"
done
