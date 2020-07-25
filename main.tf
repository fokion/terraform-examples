resource "aws_default_vpc" "default" {
  instance_tenacy = "default"
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "Default VPC"
  }
}
resource "aws_subnet" "eu-1a" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_default_vpc.default.id
  availability_zone = "eu-west-1a"
}
resource "aws_subnet" "eu-1b" {
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_default_vpc.default.id
  availability_zone = "eu-west-1b"
}

resource "aws_subnet" "eu-private-1a" {
  cidr_block = "10.0.3.0/24"
  vpc_id = aws_default_vpc.default.id
  map_public_ip_on_launch = false
  availability_zone = "eu-west-1a"
}
resource "aws_subnet" "eu-private-1b" {
  cidr_block = "10.0.4.0/24"
  vpc_id = aws_default_vpc.default.id
  map_public_ip_on_launch = false
  availability_zone = "eu-west-1b"
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_default_vpc.default.id
  tags = {
    Name = "Main Gateway"
  }
}


resource "aws_route_table" "main-routetable" {
  vpc_id = aws_default_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
  tags = {
    Name = "main-public"
  }
}

resource "aws_route_table_association" "eu_public-1a" {
  route_table_id = aws_route_table.main-routetable.id
  subnet_id = aws_subnet.eu-1a.id
}
resource "aws_route_table_association" "eu_public-1b" {
  route_table_id = aws_route_table.main-routetable.id
  subnet_id = aws_subnet.eu-1b.id
}



resource "aws_security_group" "application-sg"{
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.eu-1a.cidr_block,aws_subnet.eu-1b.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}