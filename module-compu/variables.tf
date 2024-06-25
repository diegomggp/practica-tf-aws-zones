variable "SSHLocation" {
  description      = "The IP address range that can be used to SSH to the EC2 instances"
  type             = string
  default          = "0.0.0.0/0"
  validation {
    condition     = can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", var.SSHLocation)) && length(var.SSHLocation) >= 9 && length(var.SSHLocation) <= 18
    error_message = "SSHLocation must have a length between 9 and 18 characters."
  }
}


variable "vpc_id" {
  type        = string
  description = "La id de la VPC generada en la parte-net, para stack 1 y 2"
}

variable "public_subnets" {
  type        = list(string)
  description = "La id de las subnets generadas en la parte-net, para stack 1 y 2"
}

variable "private_subnets" {
  type        = list(string)
  description = "La id de las subnets generadas en la parte-net, para stack 1 y 2"
}







