output "vpc" {
    value = module.vpc
}
output "web-sg-id" {
    value = aws_security_group.web-sg.id
}
output "web-subnet-id" {
    value =   aws_subnet.web-subnet.*.id
}
output "app-sg-id" {
    value = aws_security_group.app-sg.id
}
output "app-subnet-id" {
    value =   aws_subnet.app-subnet.*.id
}
