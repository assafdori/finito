variable "vpc_name" {
  type = string
  description = "VPC Name"
}

variable "vpc_main_cidr_block" {
  type = string
  description = "VPC CIDR block, default 10.0.0.0/16"
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type = list(object({
    ipv4_cidr_block = string
    name = string
    availability_zone = string
  }))

  default = [
    {
      ipv4_cidr_block = "10.0.1.0/24"
      name = "General"
      availability_zone = "eu-east-1a"
    }
  ]
}

variable "private_subnets" {
  type = list(object({
    ipv4_cidr_block = string
    name = string
    availability_zone = string
    layer = string
  }))

  validation {
    condition     = can(regex("^(APPLICATION|DATA)$", var.private_subnets[0].layer))
    error_message = "Invalid layer definition. Must be either: \"APPLICATION\" or \"DATA\"."
  }

  default = [
    {
      ipv4_cidr_block = "10.0.3.0/24"
      name = "Application"
      availability_zone = "eu-east-1a"
      layer = "APPLICATION"
    },
    {
      ipv4_cidr_block = "10.0.4.0/24"
      name = "Database"
      availability_zone = "eu-east-1a"
      layer = "DATA"
    }
  ]
}
/*variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet IPv4 CIDR values, default values will create two public subnet (255 hosts)"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet IPv4 CIDR values, default values will create two private subnet (255 hosts)"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}*/

variable "enable_internet_gateway" {
  type = bool
  description = "Expose the public subnet to the internet, default false."
  default = false
}

variable "enable_nat_gateway" {
  type = bool
  description = "Enable NAT Gateway for private subnet, default false."
  default = false
  
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "enable_dns_support" {
  type = bool
}
/*
variable "allowed_ssh_connect_cidr_block" {
  type = string
  validation {
    condition     = can(cidrnetmask(var.allowed_ssh_connect_cidr_block))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}
variable "allowed_http_connect_cidr_block" {
  type = string
  validation {
    condition     = can(cidrnetmask(var.allowed_http_connect_cidr_block))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}
variable "allowed_https_connect_cidr_block" {
  type = string
  validation {
    condition     = can(cidrnetmask(var.allowed_https_connect_cidr_block))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}*/
