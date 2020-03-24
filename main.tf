
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

resource "aws_launch_configuration" "example" {
      image_id= "ami-0c55b159cbfafe1f0"
      instance_type="t2.micro"
      security_groups=[aws_security_group.sg_allow8080.id]

      user_data = <<-EOF
              #!/bin/bash
              echo "Hello , World by busybox"> index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
      lifecycle{
        create_before_destroy=true
      }

}

resource "aws_autoscaling_group" "example" {
      launch_configuration=aws_launch_configuration.example.name
      vpc_zone_identifier=data.aws_subnet_ids.default.ids

      target_group_arns=[aws_lb_target_group.asg.arn]
      health_check_type="ELB"

      min_size=2
      max_size=10

      tag{
          key   ="Name"
          value ="terraform-asg-example"
          propagate_at_launch=true
      }  
}

data "aws_vpc" "default"{
  default=true
}

data "aws_subnet_ids" "default" {
  vpc_id=data.aws_vpc.default.id
}

resource "aws_lb" "example" {
  name="terraform-asg-example"
  load_balancer_type="application"
  subnets= data.aws_subnet_ids.default.ids
  security_groups=[aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn=aws_lb.example.arn
  port=80
  protocol="HTTP"
  default_action{
    type="fixed-response"
    fixed_response{
      content_type="text/plain"
      message_body="404: page not found"
      status_code=404
    }
  }
}

# create security group for ALB

resource "aws_security_group" "alb" {
  name="terraform-example-alb"

  #allow inbound http reques
  ingress{
    from_port=80
    to_port=80
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
  }

  #allow outbound request
  egress{
    from_port=0
    to_port=0
    protocol="-1"
    cidr_blocks=["0.0.0.0/0"]
  } 
}

# create TG
resource "aws_lb_target_group" "asg" {
  name="terraform-asg-example"
  port=var.server_port
  protocol="HTTP"
  vpc_id=data.aws_vpc.default.id

  health_check{
    path ="/"
    protocol="HTTP"
    matcher="200"
    interval=15
    timeout=3
    healthy_threshold=2
    unhealthy_threshold=2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn=aws_lb_listener.http.arn
  priority=100

  condition{
    field="path-pattern"
    values=["*"]
  }
  action{
    type ="forward"
    target_group_arn=aws_lb_target_group.asg.arn
  }
}

