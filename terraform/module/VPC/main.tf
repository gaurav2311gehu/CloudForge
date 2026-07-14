resource "aws_vpc" "myvpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "myvpc"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = var.public_subnet_Cidr
    availability_zone = "us-east-1a"
    tags = {
        Name = "public_subnet"
    } 
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = var.private_subnet_Cidr
    availability_zone = "us-east-1a"
    tags = {
        Name = "private_subnet"
    }
}

resource "aws_internet_gateway" "myigw" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
        Name = "myigw"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
        Name = "public_rt"
    }
}

resource "aws_route" "default_route" {
    route_table_id = aws_route_table.public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
}

resource "aws_route_table_association" "public_subnet_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id
} 

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
        Name = "private_rt"
    }
}

resource "aws_route_table_association" "private_subnet_association" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "public_sgrp" {
    name = "public_sgrp"
    description = "Allow SSH and HTTP"
    vpc_id = aws_vpc.myvpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
    }

    ingress {
        from_port = 0
        to_port = 3000
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
    }
}

resource "aws_security_group" "private_sgrp" {
    name = "private_sgrp"
    description = "Allow SSH and HTTP"
    vpc_id = aws_vpc.myvpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
    }
}