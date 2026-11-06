output "website_url" {
  description = "Public URL of the workshop page. Allow a few minutes after deployment for the instance startup script to finish."
  value       = module.web_server.website_url
}

output "instance_public_ip" {
  description = "Public IPv4 address of the EC2 instance."
  value       = module.web_server.public_ip
}

output "vpc_id" {
  description = "ID of the VPC created for this deployment."
  value       = module.network.vpc_id
}
