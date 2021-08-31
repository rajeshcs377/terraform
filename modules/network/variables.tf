

variable "vpc_cidr" {
type = any
}

variable "availability_zones" {
  type    = list
}  
variable "item_count" {
type = number
}
variable "web_subnet_cidr" {
  type    = list
}
variable "app_subnet_cidr" {
  type = list 
}
variable "db_subnet_cidr" {
  type = list 
}