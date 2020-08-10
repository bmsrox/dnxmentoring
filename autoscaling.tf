resource "aws_launch_configuration" "launchconfig" {
  name_prefix = "launchconfig"
  image_id = var.aws_ami
  instance_type = var.aws_instance_type
  key_name = var.wpkeypair
  security_groups = [aws_security_group.ec2instance.id]
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt -y install net-tools nginx
              sudo rm /etc/nginx/sites-enable/default
              sudo bash -c "echo ${data.template_file.nginx_config.rendered} > lb.conf && sudo cp lb.conf /etc/nginx/conf.d"
              sudo nginx -s reload
              MYIP=$(ifconfig | grep -E 'inet' | awk '{ print $2 }' | cut -d ':' -f2)
              sudo bash -c "echo this is: $MYIP > /var/www/html/index.html"
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "autoscaling" {
  name = "autoscaling"
  vpc_zone_identifier = aws_subnet.public.*.id
  launch_configuration = aws_launch_configuration.launchconfig.name
  min_size = 2
  max_size = 5
  desired_capacity = 2
  health_check_grace_period = 300
  health_check_type = "ELB"
  load_balancers = [aws_elb.wp-loadbalancer.name]
  force_delete = true

  tag {
    key                 = "Name"
    value               = "dnxmentoring autoscaling"
    propagate_at_launch = true
  }
}