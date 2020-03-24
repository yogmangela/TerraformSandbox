
terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region = "us-east-2"
  #region = "us-west-1"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.0"
}

resource "aws_instance" "example" {
  ami          = "ami-0c55b159cbfafe1f0"
  #ami           ="ami-031d908d7e01c66de"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_allow8080.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello , World by busybox"> index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF


  tags = {
    Name = "myInstance"
  }
}

resource "aws_security_group" "sg_allow8080" {
  name = "terraform-example"
  
  ingress{
    from_port = var.server_port//8080
    to_port   = var.server_port//8080
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*
provider "aws" {
  region = "eu-west-1"
  version = "~> 2.54"
}

resource "aws_instance" "mySandbox" {
  ami=  "ami-0eda57fdc7da72118"
  instance_type="t2.micro"
}
*/
