locals {
  public_cidr_block  = cidrsubnet(module.vpc.vpc_cidr_block, 1, 0)
  private_cidr_block = cidrsubnet(module.vpc.vpc_cidr_block, 1, 1)

  datetime = formatdate("YYYYMMDD hh:mm:ss ZZZ", timestamp())
}
