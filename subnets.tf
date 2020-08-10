resource "aws_subnet" "private" {
  count = var.az_count
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Private"
  }
}

resource "aws_subnet" "public" {
  count = var.az_count
  #var.az_count using to not cause conflict with the private
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags = {
    Name = "Public"
  }
}

resource "aws_db_subnet_group" "database" {
  name = "main-db-subnet"
  subnet_ids = aws_subnet.private.*.id

  tags = {
    Name = "dnxmentoring - DB subnet group"
  }
}