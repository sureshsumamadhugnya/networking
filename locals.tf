locals {
  public_cidr_block         = cidrsubnet(module.vpc.vpc_cidr_block, 1, 0)
  private_cidr_block        = cidrsubnet(module.vpc.vpc_cidr_block, 1, 1)
  organization_name         = var.client_vpn_organization_name == "" ? "${var.environment}.${var.namespace}" : var.client_vpn_organization_name
  vpn_subnets               = [for az, subnets in module.private_subnets.az_subnet_ids : subnets]
  ##############################################################################
  ## resource naming
  ##############################################################################
  default_base_name = "${var.namespace}-${var.environment}"

  ## vpc
  vpc_name = var.vpc_name_override != null ? var.vpc_name_override : "${local.default_base_name}-vpc"

  ## public subnets
  public_subnet_name = var.public_subnet_name_override != null ? var.public_subnet_name_override : "${local.default_base_name}-public-subnet"

  ## private subnets
  private_subnet_name = var.private_subnet_name_override != null ? var.private_subnet_name_override : "${local.default_base_name}-private-subnet"
}
