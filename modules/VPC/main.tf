resource "aws_vpc" "myvpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_classiclink   = "false"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  instance_tenancy     = "default"

  tags = {
    "Name" = "vpc-${var.name}"
    "owner" = "devakumar"
    "project" = "My DevOps project"
    "environment" = "${var.name}"
    "live" = "${var.tag_live}"
  }
}

resource "aws_nat_gateway" "ngw-b" {
  allocation_id = "${aws_eip.nat_eip-b.id}"
  subnet_id     = "${aws_subnet.public-b.id}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.myvpc.id}"

  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_vpn_gateway" "vgw" {
  vpc_id = "${aws_vpc.myvpc.id}"

  tags = {
    Name = "${var.name} VGW"
    network_id = "${var.vgw_network_id}"
  }
}


resource "aws_eip" "nat_eip-b" {
  vpc = true
}

resource "aws_customer_gateway" "cgw" {
  count      = "${var.cgw_ip != "" && var.cgw_bgp != ""  ? 1 : 0}"
  ip_address = "${var.cgw_ip}"
  type       = "ipsec.1"
  bgp_asn    = "${var.cgw_bgp}"
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${aws_vpc.myvpc.id}"
  service_name = "com.amazonaws.eu-west-1.s3"
  route_table_ids = ["${aws_route_table.public.id}", "${aws_route_table.private-a.id}", "${aws_route_table.private-b.id}", "${aws_route_table.private-c.id}"]
}

resource "aws_subnet" "public-a" {
  vpc_id            = "${aws_vpc.myvpc.id}"
  cidr_block        = "${var.subnet_public-a_cidr}"
  availability_zone = "${var.region}a"

  tags = {
    "Name" = "public-${var.name}-a"
  }
}

resource "aws_subnet" "public-b" {
  vpc_id            = "${aws_vpc.myvpc.id}"
  cidr_block        = "${var.subnet_public-b_cidr}"
  availability_zone = "${var.region}b"

  tags = {
    "Name" = "public-${var.name}-b"
  }
}

resource "aws_subnet" "public-c" {
  vpc_id            = "${aws_vpc.myvpc.id}"
  cidr_block        = "${var.subnet_public-c_cidr}"
  availability_zone = "${var.region}c"

  tags = {
    "Name" = "public-${var.name}-c"
  }
}

resource "aws_subnet" "private-a" {
  vpc_id            = "${aws_vpc.myvpc.id}"
  cidr_block        = "${var.subnet_private-a_cidr}"
  availability_zone = "${var.region}a"

  tags = {
    "Name" = "private-${var.name}-a"
  }
}

resource "aws_subnet" "private-b" {
  vpc_id            = "${aws_vpc.myvpc.id}"
  cidr_block        = "${var.subnet_private-b_cidr}"
  availability_zone = "${var.region}b"

  tags = {
    "Name" = "private-${var.name}-b"
  }
}

resource "aws_subnet" "private-c" {
  vpc_id            = "${aws_vpc.myvpc.id}"
  cidr_block        = "${var.subnet_private-c_cidr}"
  availability_zone = "${var.region}c"

  tags = {
    "Name" = "private-${var.name}-c"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.myvpc.id}"

  tags = {
    Name = "public-${var.name}"
  }
}

resource "aws_route" "public_ig" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.igw.id}"
}

resource "aws_route" "public_route" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block = "10.0.0.0/8"
  gateway_id = "${aws_vpn_gateway.vgw.id}"
}

resource "aws_route_table_association" "public-a" {
  subnet_id      = "${aws_subnet.public-a.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public-b" {
  subnet_id      = "${aws_subnet.public-b.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public-c" {
  subnet_id      = "${aws_subnet.public-c.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table" "private-a" {
  vpc_id = "${aws_vpc.myvpc.id}"

  tags = {
    Name = "private-${var.name}-a"
  }
}

resource "aws_route" "private_a_ngw" {
  route_table_id            = "${aws_route_table.private-a.id}"
  destination_cidr_block     = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.ngw-b.id}"
}

resource "aws_route" "private_a_route" {
  route_table_id            = "${aws_route_table.private-a.id}"
  destination_cidr_block = "10.0.0.0/8"
  gateway_id = "${aws_vpn_gateway.vgw.id}"
}

resource "aws_route_table_association" "private-a" {
  subnet_id      = "${aws_subnet.private-a.id}"
  route_table_id = "${aws_route_table.private-a.id}"
}

resource "aws_route_table" "private-b" {
  vpc_id = "${aws_vpc.myvpc.id}"

  tags = {
    Name = "private-${var.name}-b"
  }
}

resource "aws_route" "private_b_ngw" {
  route_table_id            = "${aws_route_table.private-b.id}"
  destination_cidr_block     = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.ngw-b.id}"
}

resource "aws_route" "private_b_route" {
  route_table_id            = "${aws_route_table.private-b.id}"
  destination_cidr_block = "10.0.0.0/8"
  gateway_id = "${aws_vpn_gateway.vgw.id}"
}


resource "aws_route_table_association" "private-b" {
  subnet_id      = "${aws_subnet.private-b.id}"
  route_table_id = "${aws_route_table.private-b.id}"
}

resource "aws_route_table" "private-c" {
  vpc_id = "${aws_vpc.myvpc.id}"

  tags  = {
    Name = "private-${var.name}-c"
  }
}

resource "aws_route" "private_c_ngw" {
  route_table_id            = "${aws_route_table.private-c.id}"
  destination_cidr_block     = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.ngw-b.id}"
}

resource "aws_route" "private_c_route" {
  route_table_id            = "${aws_route_table.private-c.id}"
  destination_cidr_block = "10.0.0.0/8"
  gateway_id = "${aws_vpn_gateway.vgw.id}"
}


resource "aws_main_route_table_association" "private-c" {
  vpc_id         = "${aws_vpc.myvpc.id}"
  route_table_id = "${aws_route_table.private-c.id}"
}
