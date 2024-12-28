network = {
  network_name        = "technion-net"
  region              = "us-west-2"
  vpc_main_cidr_block = "10.0.0.0/16"
  public_subnets = [
    {
      ipv4_cidr_block   = "10.0.0.0/24"
      name              = "Public-A"
      availability_zone = "us-west-2a"
    },
    {
      ipv4_cidr_block   = "10.0.1.0/24"
      name              = "Public-B"
      availability_zone = "us-west-2b"
    }
  ]
  private_subnets = [
    {
      ipv4_cidr_block   = "10.0.2.0/24"
      name              = "Application-A"
      availability_zone = "us-west-2a"
      layer             = "APPLICATION"
    },
    {
      ipv4_cidr_block   = "10.0.3.0/24"
      name              = "Application-B"
      availability_zone = "us-west-2b"
      layer             = "APPLICATION"
    },
    {
      ipv4_cidr_block   = "10.0.4.0/26"
      name              = "Database-A"
      availability_zone = "us-west-2a"
      layer             = "DATA"
    },
    {
      ipv4_cidr_block   = "10.0.4.64/26"
      name              = "Database-B"
      availability_zone = "us-west-2b"
      layer             = "DATA"
    }
  ]
}
