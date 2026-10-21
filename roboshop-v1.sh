#!/bin/bash

ami_id="ami-0055977a6e828a4f4"
instance_type="t3.micro"
domain_id="sandeeplinux22.store"
hosted_zone_id="Z09842261W8MW372F9VFX"


for instance in $@
do
   echo "creating instance: ${instance}"
done
