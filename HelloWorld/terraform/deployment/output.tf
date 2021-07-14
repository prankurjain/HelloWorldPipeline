output "backend_public_ips" {
  value = aws_instance.backend1.*.public_ip
}

output "backend_public_dns" {
  value = aws_instance.backend1.*.public_dns
}
