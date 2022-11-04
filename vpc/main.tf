resource "aws_vpc" "main" {
  cidr_block = "180.0.0.0/22"
  tags = {
    "Name" = "myvpc"
  }
}

resource "aws_subnet" "public-1a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "180.0.0.0/27"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "public-1a"
  }
}
resource "aws_subnet" "public-1b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "180.0.0.32/27"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "public-1b"
  }
}
resource "aws_subnet" "private-1a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "180.0.0.64/27"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "private-1a"
  }
}
resource "aws_subnet" "private-1b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "180.0.0.96/27"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "private-1b"
  }
}

resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main.id
 tags = {
   Name = "myvpc IG"
 }
}


resource "aws_route_table" "second_rt" {
 vpc_id = aws_vpc.main.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gw.id
 }
 
 tags = {
   Name = "myvpc 2nd RT"
 }
}

resource "aws_route_table_association" "public_subnet_asso" {
 subnet_id = each.value
 route_table_id = aws_route_table.second_rt.id
 for_each = toset([aws_subnet.public-1a.id,aws_subnet.public-1b.id])
}


