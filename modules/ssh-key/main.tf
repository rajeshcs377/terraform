# Generate the SSH keypair that we’ll use to configure the EC2 instance. The private key will be written to a local file and public key will be uploaed to EC2


resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "local_file" "private_key" {
  filename          = "${var.keyname}-key.pem"
  sensitive_content = tls_private_key.key.private_key_pem
  file_permission   = "0400"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.keyname}-key"
  public_key = tls_private_key.key.public_key_openssh
}