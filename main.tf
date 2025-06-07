provider "aws" {
  region = "us-east-1"
}

/*
 Create a VPC named ‘wordpress-vpc’ (add name tag).
 */
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

/*
 Create an Internet Gateway named ‘wordpress_igw’ (add name tag).
*/
resource "aws_internet_gateway" "wordpress_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.internet_gateway
  }
}

/* 
 Create a route table named ‘wordpess-rt’ and add Internet 
 Gateway route to it (add name tag).
*/
resource "aws_route_table" "wordpess-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.cidr_block_entire_inet
    gateway_id = aws_internet_gateway.wordpress_igw.id
  }

  tags = {
    Name = var.internet_gateway
  }
}

/* 
  Create 3 public and 3 private subnets in the us-east region (add 
  name tag). Associate them with the ‘wordpess-rt’ route table. 
  What subnets should be associated with the ‘wordpess-rt’ route
  table? What about other subnets? Use AWS documentation.
 */

resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = each.value.name
  }
}

resource "aws_subnet" "private_subnets" {
  for_each = var.private_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = {
    Name = each.value.name
  }
}

resource "aws_route_table_association" "wordpess-rt-association" {
  for_each = aws_subnet.public_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.wordpess-rt.id
}

/*
 Create a security group named ‘wordpress-sg’ and open HTTP, HTTPS,
 SSH ports to the Internet (add name tag). Define port numbers in
 a variable named ‘ingress_ports’. 
 */

resource "aws_security_group" "wordpress-sg" {
  description = var.wordpress-sg
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = var.wordpress-sg
  }

  egress {
    description = "allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block_entire_inet]
  }

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      description = "Allow inbound ${ingress.value.description} traffic"
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = var.tcp_protocol
      cidr_blocks = [var.cidr_block_entire_inet]
    }
  }
}

/*
 TODO: Create a key pair named ‘ssh-key’ (you can use your public key).
*/

/*
 Create an EC2 instance named ‘wordpress-ec2’ (add name tag). Use Amazon
  Linux 2 AMI (can store AMI in a variable), t2.micro, ‘wordpress-sg’ 
  security group, ‘ssh-key’ key pair, public subnet 1.
*/

resource "aws_instance" "web" {
  ami                    = var.free_tier_ami
  instance_type          = var.instance_type_t2micro
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.wordpress-sg.id]
  subnet_id              = aws_subnet.public_subnets["subnet_1"].id

  user_data = file("${path.module}/shell_scripts/wordpress.sh")

  tags = {
    Name = var.web_instance_name
  }
}

/*
 Create a security group named ‘rds-sg’ and open MySQL port and allow
  traffic only from ‘wordpress-sg’ security group (add name tag).
*/

resource "aws_security_group" "rds-sg" {
  description = var.rds_sg_name
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = var.rds_sg_name
  }
}

resource "aws_security_group_rule" "allow_mysql_from_wp" {
  type                     = "ingress"
  from_port                = var.port_3306
  to_port                  = var.port_3306
  protocol                 = var.tcp_protocol
  security_group_id        = aws_security_group.rds-sg.id
  source_security_group_id = aws_security_group.wordpress-sg.id
  description              = var.rds_sg_rule_name
}

/*
 Create a MySQL DB instance named ‘mysql’: 20GB, gp2, t2.micro instance
 class, username=admin, password=adminadmin. Use ‘aws_db_subnet_group’ 
 resource to define private subnets where the DB instance will be created.
*/

resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = var.mysql_subnet_group
  subnet_ids = [for subnet in aws_subnet.private_subnets : subnet.id]

  tags = {
    Name = var.mysql_subnet_group
  }
}

data "aws_rds_engine_version" "mysql" {
  engine             = var.db_engine
  preferred_versions = [var.db_preferred_version]
}

resource "aws_db_instance" "mysql" {
  identifier             = var.db_identifier
  engine                 = data.aws_rds_engine_version.mysql.engine
  engine_version         = data.aws_rds_engine_version.mysql.version
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  storage_type           = var.db_storage_type
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.mysql_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name = var.db_instance_name
  }
}