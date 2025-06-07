vpc_name = "wordpress-vpc"
vpc_cidr = "10.100.0.0/16"

internet_gateway = "wordpress_igw"

public_subnets = {
  subnet_1 = {
    cidr_block = "10.100.0.0/19"
    name       = "public-subnet-1"
    az         = "us-east-1a"
  }
  subnet_2 = {
    cidr_block = "10.100.32.0/19"
    name       = "public-subnet-2"
    az         = "us-east-1b"
  }
  subnet_3 = {
    cidr_block = "10.100.64.0/19"
    name       = "public-subnet-3"
    az         = "us-east-1c"
  }
}

private_subnets = {
  subnet_1 = {
    cidr_block = "10.100.96.0/19"
    name       = "private-subnet-1"
    az         = "us-east-1a"
  }
  subnet_2 = {
    cidr_block = "10.100.128.0/19"
    name       = "private-subnet-2"
    az         = "us-east-1b"
  }
  subnet_3 = {
    cidr_block = "10.100.160.0/19"
    name       = "private-subnet-3"
    az         = "us-east-1c"
  }
}

wordpress-sg           = "wordpress-sg"
cidr_block_entire_inet = "0.0.0.0/0"
tcp_protocol           = "tcp"

port_22  = 22
port_80  = 80
port_443 = 443

ingress_ports = [
  { port = 22, description = "SSH" },
  { port = 80, description = "HTTP" },
  { port = 443, description = "HTTPS" }
]

rds_sg_name        = "rds-sg"
port_3306          = 3306
rds_sg_rule_name   = "Allow MySQL from WordPress SG"
mysql_subnet_group = "mysql-subnet-group"


key_name    = "linuxkey"
db_username = "admin"
db_password = "adminadmin"

free_tier_ami         = "ami-02457590d33d576c3"
instance_type_t2micro = "t2.micro"
web_instance_name     = "wordpress-ec2"

db_instance_name     = "MySQL for WordPress"
db_instance_class    = "db.t3.micro"
db_engine            = "mysql"
db_identifier        = "mysql"
db_allocated_storage = 20
db_preferred_version = "8.0.34"
db_storage_type      = "gp2"


