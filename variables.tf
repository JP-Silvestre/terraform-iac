variable "owner_name" {
  description = "Name displayed on the web page and used in resource tags."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9 .'-]+$", var.owner_name))
    error_message = "owner_name can contain letters, numbers, spaces, periods, apostrophes, and hyphens."
  }
}

variable "project_name" {
  description = "Short name used to identify this deployment."
  type        = string
  default     = "iac-homework"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.project_name))
    error_message = "project_name may contain only letters, numbers, and hyphens."
  }
}

variable "aws_region" {
  description = "AWS region where the infrastructure will be created."
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type for the simple web server."
  type        = string
  default     = "t3.micro"
}

variable "vpc_cidr" {
  description = "CIDR block for the project VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.20.1.0/24"
}

variable "allowed_http_cidr" {
  description = "IPv4 CIDR allowed to reach the website over HTTP. Public access is required for the workshop demonstration."
  type        = string
  default     = "0.0.0.0/0"
}

variable "additional_tags" {
  description = "Extra tags to apply to every resource managed by this configuration."
  type        = map(string)
  default     = {}
}
