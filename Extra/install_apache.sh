#!/bin/bash
echo ECS_CLUSTER=ecs-emplicheck-dev >> /etc/ecs/ecs.config
#echo ECS_CLUSTER=carsaver-dev >> /etc/ecs/ecs.config

# this for Amazon linux
# sudo yum update -y
# sudo yum install -y httpd
# sudo service httpd status
# sudo service httpd start

# this for ubuntu linux
# sudo apt-get update
# sudo apt-get install -y apache2
# sudo systemctl start apache2
# sudo systemctl enable apache2
# echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html