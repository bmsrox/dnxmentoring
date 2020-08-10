resource "aws_instance" "wordpress" {
  count = var.az_count
  ami = var.aws_ami
  instance_type = var.aws_instance_type
  availability_zone = data.aws_availability_zones.available.names[count.index]
  subnet_id = element(aws_subnet.private.*.id, count.index)
  security_groups = [aws_security_group.ec2instance.id ]
  key_name = var.wpkeypair
  depends_on = [aws_db_instance.mysql]
  user_data = <<-EOF
              #!/bin/bash
              sudo echo "127.0.0.1 `hostname`" >> /etc/hosts
              sudo apt update -y
              sudo apt install -y mysql-client apache2 apache2-utils php php-cli php-mcrypt php-curl php-gd php-xmlrp php-mysql php-intl
              sudo service apache2 restart
              sudo wget -c https://wordpress.org/latest.tar.gz
              sudo tar -xzvf latest.tar.gz
              sleep 20
              sudo mkdir -p /var/www/html/
              sudo rsync -av wordpress/* /var/www/html/
              sudo chown -R www-data:www-data /var/www/html/
              sudo chmod -R 755 /var/www/html/
              sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
              sudo service apache2 restart
              sleep 20
              EOF
  tags = {
    Name = "dnxmentoring-wordpress-${count.index + 1}"
  }
}