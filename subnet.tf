
variable "public_subnets" {
  type = map(object({
    cidr_block = string
    az         = string
    name       = string
  }))
}

variable "private_subnets" {
  type = map(object({
    cidr_block = string
    az         = string
    name       = string
  }))
}

variable "mysql_subnet_group" {
  type        = string
  description = "MySQL DB subnet group"
}
