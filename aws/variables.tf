# --------------------------------------------------------------------------------------------------
# DVWA
# --------------------------------------------------------------------------------------------------
variable "listen_port" {
  description = "Port for DVWA web interface"
  default     = "8080"
}

variable "php_version" {
  description = "PHP version to run DVWA"
  default     = "8.1"
}

variable "public_key" {
  description = "SSH public key to add"
  default     = ""
}

# --------------------------------------------------------------------------------------------------
# INFRASTRUCTURE
# --------------------------------------------------------------------------------------------------
variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "vpc_subnet_cidr" {
  description = "Subnet CIDR"
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "AWS EC2 instance type to use for DVWA server"
  default     = "t3.nano"
}

variable "tags" {
  description = "Tags to add to all resources"
  default = {
    Name = "dvwa"
  }
}
