# Terraform AWS EC2 Instance Module

This is Terraform module to create AWS EC2 instances with EBS volumes of different type. It also creates Security Group for these instances having multiple options of ingress/ egress rules along with other common Security groups.

**This module requires Terraform <=v0.11.**

Here are the feature list of module:
* Create n number of EC2 instances distributed among availability zones.
* Option to attach EBS volume of different type, size, IOPs, with/ without encryption.
* It automatically creates dedicated security group too with listed ingress/ Egress options.
  * Define rule with CIDR blocks.
  * Define rule with self reference.
  * Define rule with reference of other security group ids.
* It also attaches other pre-created security groups to instance based on filters.
* It has an option to enable/disable EC2 detailed monitoring through monitoring variable and enable/disable EC2 Termination Protection.
* It gives an option to create public instance with elastic IP.

## Private EC2 instance with EBS volume, with monitoring enabled

```hcl
module "instances" {
  source             = "github.com/SanchitBansal/terraform-aws-instance.git?ref=master"
  environment        = "test"
  subnet_tags        = {
    "role" = "db"
  }

  name               = "githubmysql"
  service            = "mysql"
  key_name           = "devops-key"
  profile            = "nonprod"

  instance_count     = "3"
  instance_type      = "m4.large"
  ami                = "ami-xxxxx"

  volume_size        = "200"
  volume_type        = "io1"
  ebs_iops           = "1000"
  device_name        = "/dev/xvdg"

  monitoring         = "true"
  description        = "githubmysql security group"

  security_rule_egress_cidr = [
    {
      from_port  = "0"
      to_port    = "0"
      protocol   = "-1"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  security_rule_egress_self = [
    {
      from_port  = "3306"
      to_port    = "3306"
      protocol   = "tcp"
    },
  ]

  security_rule_ingress_self = [
    {
      from_port  = "3306"
      to_port    = "3306"
      protocol   = "tcp"
    },
  ]

  security_rule_ingress_cidr = [
    {
      from_port  = "22"
      to_port    = "22"
      protocol   = "tcp"
      cidr_blocks = "x.x.x.x/32,y.y.y.y/24"
      description = "allow access from office natted ips"
    },
    {
      from_port  = "3306"
      to_port    = "3306"
      protocol   = "tcp"
      cidr_blocks = "192.168.101.0/24"
      description = "allow mysql access from app subnet"
    },
  ]

  security_rule_ingress_groupid = [
    {
      from_port  = "22"
      to_port    = "22"
      protocol   = "tcp"
      source_security_group_id = "sg-xxxx"
      description = "allow access from bastion server"
    }
  ]

  custom_tags        = {
    role         = "database"
    businessunit = "techteam"
    organization = "github"
  }
}
```

## Public EC2 instance without EBS volume and without monitoring

```hcl
module "instances" {
  source             = "github.com/SanchitBansal/terraform-aws-instance.git?ref=master"
  environment        = "test"
  subnet_tags        = {
    "role" = "infra"
  }

  name               = "bastionserver"
  service            = "infra"
  key_name           = "devops-key"
  profile            = "nonprod"

  instance_count     = "1"
  instance_type      = "t2.medium"
  ami                = "ami-xxxxx"
  attach_ebs_volume  = "false"
  description        = "bastion security group"
  disable_api_termination = "false"

  associate_elastic_ip = "true"
  associate_public_ip_address = "true"

  security_rule_egress_cidr = [
    {
      from_port  = "0"
      to_port    = "0"
      protocol   = "-1"
      cidr_blocks = "0.0.0.0/0"
      description = "To allow all access in egress"
    },
  ]

  security_rule_ingress_cidr = [
    {
      from_port  = "22"
      to_port    = "22"
      protocol   = "tcp"
      cidr_blocks = "y.y.y.y/24"
      description = "allow access from office public ips"
    },
  ]

  custom_tags        = {
    role         = "database"
    businessunit = "techteam"
    organization = "github"
  }
}
```
