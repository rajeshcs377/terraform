output "webserver" {
  value = aws_instance.webserver.*.id
}