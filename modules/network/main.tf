data "aws_availability_zones" "available" {}

# Create a VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "ch-vpc"
  cidr = "10.0.0.0/16"

  azs = var.availability_zones
#private_subnets = var.priv_subnets                 
# public_subnets = var.pub_web_subnets
# create_database_subnet_group     = true
  enable_nat_gateway               = true
#  single_nat_gateway               = true
}

# Create Web Public Subnet
resource "aws_subnet" "web-subnet" {
  count                   = var.item_count
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.web_subnet_cidr[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Web-${count.index + 1}"
  }
}

# Create Application Private Subnet
resource "aws_subnet" "app-subnet" {
  count                   = var.item_count
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.app_subnet_cidr[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "App-${count.index + 1}"
  }
}

# Create Database Private Subnet
resource "aws_subnet" "db-subnet" {
  count             = var.item_count
  vpc_id            = module.vpc.vpc_id
  cidr_block        = var.db_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "DB-${count.index + 1}"
  }
}

# Create Web Security Group Public
resource "aws_security_group" "web-sg" {
  name        = "Web-SG"
  description = "Allow HTTP inbound traffic from anywhere"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-SG"
  }
}

# Create Application Security Group
resource "aws_security_group" "app-sg" {
  name        = "App-SG"
  description = "Allow inbound traffic from ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow traffic from web layer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "App-SG"
  }
}

#Create Database Security Group
resource "aws_security_group" "db-sg" {
  name        = "DB-SG"
  description = "Allow inbound traffic from application layer only on port 3306"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow traffic from application layer"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app-sg.id]
  }

  egress {
    from_port   = 32768
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DB-SG"
  }
}

#Create Application Load Balancer
resource "aws_lb" "app-lb" {
 name               = "APP-LB"
 internal           = false
 load_balancer_type = "application"
  security_groups    = [aws_security_group.web-sg.id]
  subnets            = [aws_subnet.web-subnet[0].id, aws_subnet.web-subnet[1].id]
}

resource "aws_lb_target_group" "app-lb" {
 name     = "ALB-TG"
 port     = 80
  protocol = "HTTP"
 vpc_id   = module.vpc.vpc_id
}

#resource "aws_lb_target_group_attachment" "app-lb" {
# count            = var.item_count
# target_group_arn = aws_lb_target_group.app-lb.arn
# target_id        = module.compute.webserver[count.index].id
# port             = 80


# depends_on = [
# aws_instance.webserver[1]
# ]
#}

#resource "aws_lb_listener" "app-lb" {
#  load_balancer_arn = aws_lb.app-lb.arn
#  port              = "80"
#  protocol          = "HTTP"

#  default_action {
#    type             = "forward"
#   target_group_arn = aws_lb_target_group.app-lb.arn
#  }
#} 
