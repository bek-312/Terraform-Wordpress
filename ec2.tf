

variable "free_tier_ami" {
  type        = string
  description = "t2.micro Free Tier eligable AMI"
}

variable "instance_type_t2micro" {
  type        = string
  description = "EC2 instance type"
}

variable "web_instance_name" {
  type = string
}

variable "db_instance_name" {
  type = string
}


variable "db_engine" {
  type = string
}

variable "db_preferred_version" {
  type = string
}

variable "db_identifier" {
  type = string
}

variable "db_allocated_storage" {
  type = number
}

variable "db_storage_type" {
  type = string
}
