### Part 1: 
## First require to deloy IAC in aws 
## - aws cli install in your system
## -  Secret key and ID required  with require permission to create resources
## - resources permissioin with IAM role, Cloudformation permissioin  

## Before apply configure aws cli 
## tyep blow command to configure aws cli
aws configure

## add your Secret key and ID and region with output json or text

## check Aws cli configure or not using check aws s3 bucket list:
aws s3 ls

## IF you see your s3 bucket list then AWS cli is ok


## install teraform in your laptop:
## https://www.terraform.io/downloads

## Ref: https://learn.hashicorp.com/tutorials/terraform/install-cli
#       or 
##  Ref : https://www.terraform.io/cli/install/apt    


## Part2: 
#### Terraform
## type command to check terraform version
terraform -version      
## minimum 1.2 version required

## 1. First commnad to verify or install terraform require packgaes for the project:
terraform init

## 2. second terraform verify code
terraform validate

## 3. Terraform plan check which resource you are createing using terraform
terraform plan

## 4. Terraform apply 
terraform apply -var-file=".dev.tfvars"
## or
terraform apply -auto-approve 

terraform apply -auto-approve -var-file=".dev.tfvars"