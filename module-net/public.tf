
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidrs) 
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.public_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = true

    tags = {
      # Name = format("Subnet%#v", count.index + 1)
      Name = "SubnetPub${count.index + 1}"
      Type = "Public"
    }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Public"
  }
}

resource "aws_route_table_association" "rta" {
  count = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.rt.id
}

# resource "aws_route_table_association" "rta2" {
#   subnet_id      = aws_subnet.public_subnet2.id
#   route_table_id = aws_route_table.rt.id
# }