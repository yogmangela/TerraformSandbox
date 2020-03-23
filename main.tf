
terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  # region = "us-east-2"
  region = "eu-west-1"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.0"
}

resource "aws_instance" "example" {
  #ami          = "ami-0c55b159cbfafe1f0"
  ami           ="ami-047bb4163c506cd98"
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-example"
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
