variable "region" {
  type = string
}
variable "network_name" {
  type = string
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

variable "database_port" {
  type = number
}