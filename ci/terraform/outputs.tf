output "private_key" {
  value = tls_private_key.example.private_key_pem
  sensitive = true
}

output "public_ip" {
  value = aws_instance.neighborly-server.public_ip
}
