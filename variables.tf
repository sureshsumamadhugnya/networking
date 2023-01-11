################################################################################
## shared
################################################################################
variable "environment" {
  type        = string
  description = "Name of the environment, i.e. dev, stage, prod"
}

variable "namespace" {
  type        = string
  description = "Namespace of the project, i.e. refarch"
}

variable "tags" {
  type        = map(string)
  description = "Default tags to apply to every resource"
}

################################################################################
## vpc
################################################################################
variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones to deploy resources in."
}

variable "vpc_ipv4_primary_cidr_block" {
  type        = string
  description = "IPv4 CIDR block for the VPC to use."
}

variable "default_network_acl_deny_all" {
  type        = bool
  default     = false
  description = <<-EOT
    When `true`, manage the default network acl and remove all rules, disabling all ingress and egress.
    When `false`, do not mange the default networking acl, allowing it to be managed by another component.
    EOT
}

variable "default_route_table_no_routes" {
  type        = bool
  default     = false
  description = <<-EOT
    When `true`, manage the default route table and remove all routes, disabling all ingress and egress.
    When `false`, do not mange the default route table, allowing it to be managed by another component.
    Conflicts with Terraform resource `aws_main_route_table_association`.
    EOT
}

variable "internet_gateway_enabled" {
  type        = bool
  description = "Set `true` to create an Internet Gateway for the VPC"
  default     = true
}

variable "dns_hostnames_enabled" {
  type        = bool
  description = "Set `true` to enable [DNS hostnames](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html#vpc-dns-hostnames) in the VPC"
  default     = true
}

variable "dns_support_enabled" {
  type        = bool
  description = "Set `true` to enable DNS resolution in the VPC through the Amazon provided DNS server"
  default     = true
}

variable "default_security_group_deny_all" {
  type        = bool
  default     = true
  description = <<-EOT
    When `true`, manage the default security group and remove all rules, disabling all ingress and egress.
    When `false`, do not manage the default security group, allowing it to be managed by another component.
    EOT
}

variable "assign_generated_ipv6_cidr_block" {
  type        = bool
  description = "When `true`, assign AWS generated IPv6 CIDR block to the VPC.  Conflicts with `ipv6_ipam_pool_id`."
  default     = true
}

variable "ipv6_egress_only_internet_gateway_enabled" {
  type        = bool
  description = "Set `true` to create an IPv6 Egress-Only Internet Gateway for the VPC"
  default     = false
}

################################################################################
## vpc endpoint
################################################################################
variable "vpc_endpoints_enabled" {
  type        = bool
  description = "Enable VPC endpoints."
  default     = false
}

variable "gateway_vpc_endpoints" {
  type = map(object({
    name            = string
    policy          = string
    route_table_ids = list(string)
  }))
  description = <<-EOT
    A map of Gateway VPC Endpoints to provision into the VPC. This is a map of objects with the following attributes:
    - `name`: Short service name (either "s3" or "dynamodb")
    - `policy` = A policy (as JSON string) to attach to the endpoint that controls access to the service. May be `null` for full access.
    - `route_table_ids`: List of route tables to associate the gateway with. Routes to the gateway
      will be automatically added to these route tables.
    EOT
  default     = {}
}

variable "interface_vpc_endpoints" {
  type = map(object({
    name                = string
    policy              = string
    private_dns_enabled = bool
    security_group_ids  = list(string)
    subnet_ids          = list(string)
  }))
  description = <<-EOT
    A map of Interface VPC Endpoints to provision into the VPC.
    This is a map of objects with the following attributes:
    - `name`: Simple name of the service, like "ec2" or "redshift"
    - `policy`: A policy (as JSON string) to attach to the endpoint that controls access to the service. May be `null` for full access.
    - `private_dns_enabled`: Set `true` to associate a private hosted zone with the specified VPC
    - `security_group_ids`: The ID of one or more security groups to associate with the network interface. The first
      security group will replace the default association with the VPC's default security group. If you want
      to maintain the association with the default security group, either leave `security_group_ids` empty or
      include the default security group ID in the list.
    - `subnet_ids`: List of subnet in which to install the endpoints.
   EOT
  default     = {}
}
