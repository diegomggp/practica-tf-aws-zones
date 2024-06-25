locals {
  configured_region = data.aws_region.current.name

  zone_list = data.aws_availability_zones.available.names
  total_zones = length(local.zone_list)
  half_length = ceil(local.total_zones / 2)

  first_half = slice(local.zone_list, 0, local.half_length)
  second_half = slice(local.zone_list, local.half_length, local.total_zones)

 
  subnets_st1 = [
    for i in range(length(local.first_half)*2) : cidrsubnet("10.0.0.0/16", 8, i)
  ]

  private_subnet_cidrs_div_st1 = slice(local.subnets_st1, 0, length(local.first_half))

  public_subnet_cidrs_div_st1 = slice(local.subnets_st1, length(local.first_half), length(local.first_half)*2)

  subnets_st2 = [
    for i in range(length(local.second_half)*2) : cidrsubnet("10.1.0.0/16", 8, i)
  ]

  private_subnet_cidrs_div_st2 = slice(local.subnets_st2, 0, length(local.second_half))
  
  public_subnet_cidrs_div_st2 = slice(local.subnets_st2, length(local.second_half), length(local.second_half)*2)
}