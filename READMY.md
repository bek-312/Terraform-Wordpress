With Terraform:

Create a VPC named ‘wordpress-vpc’ (add name tag).

Create an Internet Gateway named ‘wordpress_igw’ (add name tag).

Create a route table named ‘wordpess-rt’ and add Internet Gateway route to it (add name tag).

Create 3 public and 3 private subnets in the us-east region (add name tag). Associate them with the ‘wordpess-rt’ route table. What subnets should be associated with the ‘wordpess-rt’ route table? What about other subnets? Use AWS documentation.

Create a security group named ‘wordpress-sg’ and open HTTP, HTTPS, SSH ports to the Internet (add name tag). Define port numbers in a variable named ‘ingress_ports’.

Create a key pair named ‘ssh-key’ (you can use your public key).

Create an EC2 instance named ‘wordpress-ec2’ (add name tag). Use Amazon Linux 2 AMI (can store AMI in a variable), t2.micro, ‘wordpress-sg’ security group, ‘ssh-key’ key pair, public subnet 1.

Create a security group named ‘rds-sg’ and open MySQL port and allow traffic only from ‘wordpress-sg’ security group (add name tag).

Create a MySQL DB instance named ‘mysql’: 20GB, gp2, t2.micro instance class, username=admin, password=adminadmin. Use ‘aws_db_subnet_group’ resource to define private subnets where the DB instance will be created.

 