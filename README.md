# Three-Tier-Architecture using Terraform in AWS Cloud
In this project, we will be using Terraform (HCL) to setup a Three-Tier Architecture using the AWS provider. 
Modules have been integrated with our resources and will be located in the main.tf file. 
Finally, you will see there is a backends.tf file which has been created using S3 and a DynamoDB Table in AWS. Doing so, will enable both a remote backend and state locking for our infrastructure. In this scenario, we applied our infrastructure to the AWS Cloud and then moved our state files from the local backend to our new remote backend.
