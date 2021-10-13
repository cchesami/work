provider "aws" {
  access_key = var.aws_access_key
  region = var.aws_region
  secret_key = var.aws_secret_key
}
variable "aws_region" {}
variable "myvpc_cidr" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "mysubnet_cidr" {}
variable "myavailabilityZone" {}
variable "route-cidr" {}
variable "cidr_for_security_group" {}
variable "ami" {}
variable "type" {}
variable "security_keypair" {}
variable "public_ip" {}
variable "security_group_name" {}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.myvpc_cidr
  tags = {
    Name = "my_vpc"
  }
}
resource "aws_subnet" "my_subnet" {
  cidr_block = var.mysubnet_cidr
  vpc_id = aws_vpc.my_vpc.id
  availability_zone = var.myavailabilityZone
  tags = {
    Name = "mysubnet"

  }
}
resource "aws_internet_gateway" "myIG" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "myIG"
  }
}
resource "aws_route_table" "my_routetable" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = var.route-cidr
    gateway_id = aws_internet_gateway.myIG.id
  }
  tags = {
    Name = "my_route_table"
  }
}
resource "aws_route_table_association" "my_route_table_asso" {
  route_table_id = aws_route_table.my_routetable.id
  subnet_id = aws_subnet.my_subnet.id
}
resource "aws_security_group" "my_secuirty_group" {
  name = var.security_group_name
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "Came"
  }
  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = [var.cidr_for_security_group]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = [var.cidr_for_security_group]
  }
}
resource "aws_instance" "my_instance" {
  ami = var.ami
  instance_type = var.type
  subnet_id = aws_subnet.my_subnet.id
  availability_zone = var.myavailabilityZone
  key_name = var.security_keypair
  count = 3
  vpc_security_group_ids = [aws_security_group.my_secuirty_group.id]
  associate_public_ip_address = var.public_ip
  tags = {
    Name = "my_instance.${count.index}"
  }
}

