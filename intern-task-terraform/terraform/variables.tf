variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "Ubuntu AMI for the instance (user_data relies on apt and ufw). Placeholder default, since the instance is never launched in this task."
  type        = string
  default     = "ami-0123456789abcdef0"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "admin_user" {
  description = "Name of the non-root user created on the instance."
  type        = string
  default     = "deploy"
}

variable "ssh_allowed_cidr" {
  description = "The single CIDR allowed to SSH to the instance, for example 203.0.113.10/32. No default on purpose."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.ssh_allowed_cidr)) && var.ssh_allowed_cidr != "0.0.0.0/0"
    error_message = "ssh_allowed_cidr must be a valid CIDR block and must not be 0.0.0.0/0."
  }
}

variable "ssh_public_key" {
  description = "Public SSH key installed for the non-root user. No default on purpose."
  type        = string
}

variable "app_port" {
  description = "Port the app listens on. Must match PORT and EXPOSE in intern-task-app/Dockerfile."
  type        = number
  default     = 8080
}
