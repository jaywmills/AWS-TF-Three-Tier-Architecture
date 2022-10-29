# Remote backend configuration with S3 and State Locking with DynamoDB Tables

terraform {
  backend "s3" {
    bucket         = "terraform-s3-remote-backend-three-tier-architecture"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-s3-backend"
  }
}
