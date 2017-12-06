resource "aws_vpc" "terraws" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "terraws" {
  vpc_id = "${aws_vpc.terraws.id}"
}

resource "aws_route" "default" {
  route_table_id          = "${aws_vpc.terraws.main_route_table_id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = "${aws_internet_gateway.terraws.id}"
}

# Create subnets for load balancers
resource "aws_subnet" "elb-us-east-1a" {
  vpc_id                  = "${aws_vpc.terraws.id}"
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "elb-us-east-1b" {
  vpc_id                  = "${aws_vpc.terraws.id}"
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "elb-us-east-1c" {
  vpc_id                  = "${aws_vpc.terraws.id}"
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true
}

# Create subnets for web instances
resource "aws_subnet" "web-us-east-1a" {
  vpc_id                  = "${aws_vpc.terraws.id}"
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "web-us-east-1b" {
  vpc_id                  = "${aws_vpc.terraws.id}"
  cidr_block              = "10.0.11.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "web-us-east-1c" {
  vpc_id                  = "${aws_vpc.terraws.id}"
  cidr_block              = "10.0.12.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true
}
