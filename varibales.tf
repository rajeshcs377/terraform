variable "region" {
  description = "AWS region"
  default     = "eu-west-1"
  type        = string
}

variable "vpc_cidr" {
  type    = any
  default = "10.0.0.0/16"
}
variable "web_subnet_cidr" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "app_subnet_cidr" {
  type    = list(any)
  default = ["10.0.4.0/24", "10.0.5.0/24"]
}
variable "db_subnet_cidr" {
  type    = list(any)
  default = ["10.0.8.0/24", "10.0.9.0/24"]
}
variable "item_count" {
  type    = number
  default = 2
}

variable "availability_zones" {
  type    = list(any)
  default = ["eu-west-1a", "eu-west-1b"]
}

variable "ami_id" {
  type    = string
  default = "ami-02b4e72b17337d6c1"

}
variable "ec2_type" {
  type    = string
  default = "t2.micro"
}
 variable "keyname" {
  type = string
  default = "ch-key"
 }