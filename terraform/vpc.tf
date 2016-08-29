// Available AZs for account
data "aws_availability_zones" "available_azs" {
  state = "available"
}

// Top-level VPC resource

resource "aws_vpc" "demovpc" {
    cidr_block = "${var.vpc_cidr_block}"
    enable_dns_hostnames = true
    tags {
        CostCenter = "${var.cost_center}"
    }
}

// Public subnets

resource "aws_subnet" "public_subnet_1" {
    vpc_id = "${aws_vpc.demovpc.id}"
    cidr_block = "${var.public_cidr_block_1}"
    map_public_ip_on_launch = false
    availability_zone = "${data.aws_availability_zones.available_azs.names[0]}"
}

resource "aws_subnet" "public_subnet_2" {
    vpc_id = "${aws_vpc.demovpc.id}"
    cidr_block = "${var.public_cidr_block_2}"
    map_public_ip_on_launch = false
    availability_zone = "${data.aws_availability_zones.available_azs.names[1]}"
}

// Private subnets

resource "aws_subnet" "private_subnet_1" {
    vpc_id = "${aws_vpc.demovpc.id}"
    cidr_block = "${var.private_cidr_block_1}"
    map_public_ip_on_launch = false
    availability_zone = "${data.aws_availability_zones.available_azs.names[0]}"
}

resource "aws_subnet" "private_subnet_2" {
    vpc_id = "${aws_vpc.demovpc.id}"
    cidr_block = "${var.private_cidr_block_2}"
    map_public_ip_on_launch = false
    availability_zone = "${data.aws_availability_zones.available_azs.names[1]}"
}

// Internet Gateway

resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.demovpc.id}"
    tags {
        CostCenter = "${var.cost_center}"
    }
}

// Routing for public subnets

resource "aws_route_table" "public_rt" {
    vpc_id = "${aws_vpc.demovpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }
}

resource "aws_route_table_association" "rt_assoc_public_1" {
    subnet_id = "${aws_subnet.public_subnet_1.id}"
    route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_route_table_association" "rt_assoc_public_2" {
    subnet_id = "${aws_subnet.public_subnet_2.id}"
    route_table_id = "${aws_route_table.public_rt.id}"
}

// NAT Gateway

resource "aws_eip" "nat_eip" {
  vpc      = true
}

resource "aws_nat_gateway" "nat_gw" {
    allocation_id = "${aws_eip.nat_eip.id}"
    subnet_id = "${aws_subnet.public_subnet_1.id}"
    depends_on = ["aws_internet_gateway.igw"]
}

// Routing for private subnets

resource "aws_route_table" "private_rt" {
    vpc_id = "${aws_vpc.demovpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.nat_gw.id}"
    }
}

resource "aws_route_table_association" "rt_assoc_private_1" {
    subnet_id = "${aws_subnet.private_subnet_1.id}"
    route_table_id = "${aws_route_table.private_rt.id}"
}

resource "aws_route_table_association" "rt_assoc_private_2" {
    subnet_id = "${aws_subnet.private_subnet_2.id}"
    route_table_id = "${aws_route_table.private_rt.id}"
}
