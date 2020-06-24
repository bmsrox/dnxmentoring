output "ELB" {
  value = aws_elb.wp-loadbalancer.dns_name
}