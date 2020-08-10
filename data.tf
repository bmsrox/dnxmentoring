data "aws_availability_zones" "available" {}

data "template_file" "nginx_config" {
  template = file("scripts/nginx.conf.tpl")
  vars = {
     upstream_list = join(",", aws_instance.wordpress.*.private_ip)
  }
}