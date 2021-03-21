output "public_ip" {
  description = "Public IP address of EC2 instance containing DVWA web interface"
  value       = aws_instance.web.public_ip
}

output "dvwa_web_uri" {
  description = "DVWA web interface uri"
  value       = "http://${aws_instance.web.public_ip}:${var.listen_port}"
}

output "dvwa_ssh_uri" {
  description = "DVWA SSH uri"
  value       = "ssh ubuntu@${aws_instance.web.public_ip}"
}
