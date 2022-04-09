 resource "aws_vpc" "Main" {                # Creating VPC here
   cidr_block       = var.main_vpc_cidr     # Defining the CIDR block use 10.0.0.0/24 for demo
   instance_tenancy = "default"
 }

 resource "aws_internet_gateway" "IGW" {    # Creating Internet Gateway
    vpc_id =  aws_vpc.Main.id               # vpc_id will be generated after we create VPC
 }

 resource "aws_subnet" "public_subnet_1" {    # Creating Public Subnets
   vpc_id =  aws_vpc.Main.id
   cidr_block = var.public_subnet_1        # CIDR block of public subnets

   tags = {
     Name = "public subnet 1"
   }
 }

  resource "aws_subnet" "public_subnet_2" {    # Creating Public Subnets
   vpc_id =  aws_vpc.Main.id
   cidr_block = var.public_subnet_2        # CIDR block of public subnets

    tags = {
     Name = "public subnet 2"
   }
 }
                  # Creating Private Subnets
 resource "aws_subnet" "private_subnet_1" {
   vpc_id =  aws_vpc.Main.id
   cidr_block = var.private_subnet_1          # CIDR block of private subnets

   tags = {
     Name = "private subnet 1"
   }
 }

 resource "aws_subnet" "private_subnet_2" {
   vpc_id =  aws_vpc.Main.id
   cidr_block = var.private_subnet_2          # CIDR block of private subnets

   tags = {
     Name = "private subnet 2"
   }
 }

 resource "aws_route_table" "PublicRT" {    # Creating RT for Public Subnet
    vpc_id =  aws_vpc.Main.id
         route {
    cidr_block = "0.0.0.0/0"               # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
     }
 }


 resource "aws_route_table" "PrivateRT" {    # Creating RT for Private Subnet
   vpc_id = aws_vpc.Main.id
   route {
   cidr_block = "0.0.0.0/0"             # Traffic from Private Subnet reaches Internet via NAT Gateway
   nat_gateway_id = aws_nat_gateway.NATgw.id
   }
 }

 resource "aws_route_table_association_public_1" "PublicRTassociation" {
    subnet_id = aws_subnet.public_subnet_1.id
    route_table_id = aws_route_table.PublicRT.id
 }

  resource "aws_route_table_association_public_2" "PublicRTassociation" {
    subnet_id = aws_subnet.public_subnet_2.id
    route_table_id = aws_route_table.PublicRT.id
 }

 resource "aws_route_table_association_private_1" "PrivateRTassociation" {
    subnet_id = aws_subnet.private_subnet_1.id
    route_table_id = aws_route_table.PrivateRT.id
 }

 resource "aws_route_table_association_private_2" "PrivateRTassociation" {
    subnet_id = aws_subnet.private_subnet_2.id
    route_table_id = aws_route_table.PrivateRT.id
 }

 resource "aws_eip" "nateIP" {
   vpc   = true
 }

 resource "aws_nat_gateway_1" "NATgw" {
   allocation_id = aws_eip.nateIP.id
   subnet_id = aws_subnet.public_subnet_1.id
 }

 resource "aws_nat_gateway_2" "NATgw" {
   allocation_id = aws_eip.nateIP.id
   subnet_id = aws_subnet.public_subnet_2.id
 }