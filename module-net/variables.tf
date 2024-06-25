variable "availability_zones" {
  type = list(string)
}

variable "vpc_cidr_block" {
  type        = string
  description = "Bloque VPC cidr. Ejemplo: 10.10.0.0/16" 
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Bloque VPC cidr. Ejemplo: 10.10.0.0/16"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Bloque VPC cidr. Ejemplo: 10.10.0.0/16"
}

