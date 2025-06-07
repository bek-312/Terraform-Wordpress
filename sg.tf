
variable "wordpress-sg" {
  type        = string
  description = "wordpress-sg"
}

variable "cidr_block_entire_inet" {
  type        = string
  description = "allow connection to whole internet"
}

variable "port_22" {
  type        = number
  description = "Port 22"
}

variable "port_80" {
  type        = number
  description = "Port 80"
}

variable "port_443" {
  type        = number
  description = "Port 443"
}

variable "tcp_protocol" {
  type        = string
  description = "tcp protocol"
}

variable "rds_sg_name" {
  type        = string
  description = "rds-sg"
}

variable "port_3306" {
  type        = number
  description = "MySQL port 3306"
}

variable "rds_sg_rule_name" {
  type        = string
  description = "MySQL port 3306"
}

variable "ingress_ports" {
  type = list(object({
    port        = number
    description = string
  }))
  description = "List of ingress ports with descriptions"
}