variable "ami" {
  default = "ami-05fa00d4c63e32376"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  type      = string
  default   = ("~/.ssh/tf_keypair.pub")
  sensitive = true
}

variable "vpc_azs" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
}

variable "allocated_storage" {
  default = "10"
}

variable "vpc_id" {
  default = "10.0.0.0/16"
}

variable "public_access_cidr" {
  default = "0.0.0.0/0"
}

variable "engine_version" {
  default = "13.7"
}

variable "instance_class" {
  default = "db.t3.micro"
}

variable "db_name" {
  default = "PostgreSQL_DB"
}

variable "engine" {
  default = "postgres"
}

variable "app_tier_sn_count" {
  type    = number
  default = 2
}

variable "private_sn_count" {
  type    = number
  default = 2
}

variable "public_sn_count" {
  type    = number
  default = 2
}