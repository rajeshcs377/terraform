variable "item_count" {
  type = number  
}
variable "ami_id" {
  type = string
}
variable "ec2_type" {
  type = string
}
variable "availability_zones" {
  type = list
}
variable "vpc" {
   type = any 
}
variable "web-sg-id" {
    type = any
}
variable "web-subnet-id" {
   type = list
}

variable "app-sg-id" {
    type = any
}
variable "app-subnet-id" {
   type = list
}
variable "key_name" {
  type = string
}
