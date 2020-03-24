output "public_ip" {
  value = aws_instance.example.public_ip
  #value= concat((aws_instance.example.public_ip),(var.server_port))

}
