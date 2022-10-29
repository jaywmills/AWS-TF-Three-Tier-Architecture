variable "vpc_cidr" {}

variable "vpc_id" {
  default = "10.0.0.0/16"
}

variable "public_cidrs" {
  type = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "private_cidrs" {
  type = list(any)
  default = ["10.0.10.0/24", "10.0.11.0/24"]
}
variable "app_tier_cidrs" {
  type = list(any)
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "app_tier_sn_count" {
  type = number
  default = 2
}

variable "private_sn_count" {
  type = number
  default = 2
}

variable "public_sn_count" {
  type = number
  default = 2
}