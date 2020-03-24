output "public_ip" {
  value = aws_instance.example.public_ip
  #value= concat((aws_instance.example.public_ip),(var.server_port))
}

output "alb_dns_name" {
  value = aws_lb.example.dns_name
  description="the domain of the LB"
}

