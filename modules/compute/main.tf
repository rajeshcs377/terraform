

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

#Create EC2 Instance in public subnet (Web servers)
resource "aws_instance" "webserver" {
  count                  = var.item_count
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.ec2_type
  availability_zone      = var.availability_zones[count.index]
  vpc_security_group_ids = [var.web-sg-id]
  subnet_id              = var.web-subnet-id[count.index]
  associate_public_ip_address = true
  key_name                    = var.key_name
  tags = {
    Name = "Web Server${count.index}"
  }

}

#Create EC2 Instance in private subnet (App servers)
resource "aws_instance" "appserver" {
  count                  = var.item_count
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.ec2_type
  availability_zone      = var.availability_zones[count.index]
  vpc_security_group_ids = [var.app-sg-id]
  subnet_id              = var.app-subnet-id[count.index]
  associate_public_ip_address = false
  key_name                    = var.key_name
  tags = {
    Name = "App Server${count.index}"
  }

}