provider "aws" {
    region = "ap-south-1"  
}

resource "aws_vpc" "test-01" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Test_VPC"
  }
}

#Subnet Creation 
resource "aws_subnet" "public-01" {
  vpc_id     = aws_vpc.test-01.id
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "Subnet_test-01"
  }
}

#Internet Gateway 
resource "aws_internet_gateway" "gateway" {
    vpc_id = aws_vpc.test-01.id

    tags = {
      Name = "Internet_Gateway-01"
    }
}

resource "aws_route_table" "sub01_rt" {
    vpc_id = aws_vpc.test-01.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gateway.id
        
    }
    tags = {
        Name = "route_table_01"

    }
}

resource "aws_route_table_association" "Rt01" {
  subnet_id      = aws_subnet.public-01.id
  route_table_id = aws_route_table.sub01_rt.id
}
  
#-------------------------------------------------Machine code_-----------------------------------------------------------------------------------------------------
locals {
  ports = [80, 22, 443]
}

resource "aws_security_group" "mysg" {
  vpc_id = aws_vpc.test-01.id
  name        = "webserver"
  description = "Inbound and Outbound Rules for WebServer"

  dynamic "ingress" {
    for_each = local.ports
    content {
      description = "description ${ingress.key}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "demo-terraform" {
  ami             = "ami-0f58b397bc5c1f2e8"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public-01.id
  security_groups = [aws_security_group.mysg.id]
  key_name        = "jenkins_keys"

  tags = {
    Name = "demo-terraform"
  }
}
