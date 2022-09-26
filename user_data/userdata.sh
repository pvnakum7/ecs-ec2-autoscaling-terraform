#!/bin/bash

echo ECS_CLUSTER=${ecs_clustername} >> /etc/ecs/ecs.config 

sudo yum install -y wget
sudo yum install -y amazon-efs-utils
sudo mkdir /mnt/efs
sudo chmod -R 777 /mnt/efs/
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-0b16b51786986cf4d.efs.us-east-1.amazonaws.com:/ /mnt/efs