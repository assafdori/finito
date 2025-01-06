variable "aws_region" {
  default     = "us-west-2"
}

variable "environment" {
  default     = "technion"
}

variable "key_name" {
  default     = "redacted"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "technion-final-project"
}

variable "availability_zones" {
  type        = list(string)
  default = ["us-west-2"]
}

variable "vpc_cidr" {
  type = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "public_subnets" {
  type        = list(string)
  default     = ["10.0.3.0/24"]
}
