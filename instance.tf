resource "aws_instance" "wordpress" {
  count = var.az_count
  ami = var.aws_ami
  instance_type = var.aws_instance_type
  availability_zone = data.aws_availability_zones.available.names[count.index]
  subnet_id = element(aws_subnet.private.*.id, count.index)
  security_groups = [aws_security_group.ec2instance.id]
  
  tags = {
    Name = "dnxmentoring-wordpress"
  }
}