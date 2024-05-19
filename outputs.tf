output "url" {
  description = "URL"
  value       = "https://${var.route53_subdomain}.${var.route53_zone}"
}

output "ssh_login" {
  description = "SSH login command"
  value       = "ssh -i tfesshkey.pem ubuntu@${var.route53_subdomain}.${var.route53_zone}"
}