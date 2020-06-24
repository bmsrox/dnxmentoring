resource "aws_eip" "gateway" {
  count = var.az_count
  vpc = true

  tags = {
    Environment = "dnxmentoring"
  }
}

resource "aws_nat_gateway" "gateway" {
  count = var.az_count
  subnet_id = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.gateway.*.id, count.index)

  tags = {
    Environment = "dnxmentoring"
  }
}