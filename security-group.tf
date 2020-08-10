resource "aws_security_group" "ec2instance" {
  vpc_id = aws_vpc.main.id
  name = "ec2instance"
  description = "security group for instances"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.elb-securitygroup.id]
  }

  tags = {
    Name = "ec2instance"
  }
}

resource "aws_security_group" "elb-securitygroup" {
  vpc_id = aws_vpc.main.id
  name = "elb-securitygroup"
  description = "security group that allows ssh and all egress traffic"
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dnmentoring-lb-sg"
  }
}

resource "aws_security_group" "database" {
  name = "database"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dnxmentoring"
  }

  ingress {
    protocol = "tcp"
    from_port = 3306
    to_port = 3306
    security_groups = [aws_security_group.ec2instance.id]
  }

  egress {
    protocol = -1
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}