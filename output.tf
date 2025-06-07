output "ssh_command" {
  value       = "ssh -i ~/${var.key_name}.pem ec2-user@${aws_instance.web.public_ip}"
  description = "Command to SSH into your EC2 instance"
}

output "webserver_pub_address" {
  value = aws_instance.web.public_ip
}
