################################################################################
## defaults
################################################################################
terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0, >= 4.0.0, >= 4.9.0"
    }

    awsutils = {
      source  = "cloudposse/awsutils"
      version = "~> 0.15"
    }
  }
}

################################################################################
## vpc
################################################################################
module "vpc" {
  source = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=2.0.0"

  name = local.vpc_name

  ## networking / dns
  default_network_acl_deny_all  = var.default_network_acl_deny_all
  default_route_table_no_routes = var.default_route_table_no_routes
  internet_gateway_enabled      = var.internet_gateway_enabled
  dns_hostnames_enabled         = var.dns_hostnames_enabled
  dns_support_enabled           = var.dns_support_enabled

  ## security
  default_security_group_deny_all = var.default_security_group_deny_all

  ## ipv4 support
  ipv4_primary_cidr_block = var.vpc_ipv4_primary_cidr_block

  ## ipv6 support
  assign_generated_ipv6_cidr_block          = var.assign_generated_ipv6_cidr_block
  ipv6_egress_only_internet_gateway_enabled = var.ipv6_egress_only_internet_gateway_enabled

  tags = merge(var.tags, tomap({
    Name = local.vpc_name,
  }))
}
## subnets
################################################################################
module "public_subnets" {
  source = "git::https://github.com/cloudposse/terraform-aws-multi-az-subnets.git?ref=0.15.0"

  enabled             = var.auto_generate_multi_az_subnets
  name                = local.public_subnet_name
  type                = "public"
  vpc_id              = module.vpc.vpc_id
  availability_zones  = var.availability_zones
  cidr_block          = local.public_cidr_block
  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = "true"

  tags = merge(var.tags, tomap({
    Name = local.public_subnet_name
  }))
}

module "private_subnets" {
  source = "git::https://github.com/cloudposse/terraform-aws-multi-az-subnets.git?ref=0.15.0"

  enabled            = var.auto_generate_multi_az_subnets
  name               = local.private_subnet_name
  type               = "private"
  vpc_id             = module.vpc.vpc_id
  availability_zones = var.availability_zones
  cidr_block         = local.private_cidr_block
  az_ngw_ids         = module.public_subnets.az_ngw_ids

  tags = merge(var.tags, tomap({
    Name = local.private_subnet_name
  }))
}
