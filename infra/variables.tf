variable "network" {
  type = object({
    network_name = string
    region = string
    vpc_main_cidr_block = string
    public_subnets = list(object({
      ipv4_cidr_block = string
      name = string
      availability_zone = string
    }))
    private_subnets = list(object({
      ipv4_cidr_block = string
      name = string
      availability_zone = string
      layer = string
    }))
  })
}
