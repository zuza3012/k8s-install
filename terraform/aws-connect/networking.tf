# Create a VPC
resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_network

	tags = {
    Name = "myvpc"
  }

}

resource "aws_subnet" "pub1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.public_subnet
	availability_zone = "eu-west-1a"
  tags = {
    Name = "pub1"
  }
}



resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "pub_rtb" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "pub_rtb"
  }
}

resource "aws_route_table_association" "pub" {
  subnet_id      = aws_subnet.pub1.id
  route_table_id = aws_route_table.pub_rtb.id
}


resource "aws_security_group" "secgrp_pub" {

  name        = "ex1-secgrp-pub"
  description = "Allow SSH"
  vpc_id      = aws_vpc.myvpc.id

  ingress {

    description = "SSH ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}
