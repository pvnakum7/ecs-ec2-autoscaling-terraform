Note: Only change require in the Var changes for new service or definition


1. Number of EC2 instances: 2 
 Minimum number of instanes = 2

2. Every container single Task definition
-Name like: frontend,api,admin, landing,html, adminfront, esign, mq, oms , cron, docs

3. Single task with single Service
-Name like: frontend,api,admin, landing,html, adminfront, esign, mq, oms , cron, docs


4. Every service with single service task with service task automation
-Task - automation for:  frontend,api,admin, landing,html, adminfront, esign, mq, oms , cron, docs
- Automation policy apply for service task 80 % of container cpu and memory
-Service task monitoring cloud watch

5 Single ALB with multiple target groups
-Single ALB
-Multiple target groups
-Every target group for every single service 