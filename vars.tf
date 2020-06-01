variable "profile" {
  description = "profile name to get valid credentials of account"
}

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "ap-south-1"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = "list"
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "ami" {
  description = "The ami to launch instance in"
}
variable "user_data" {
  default = ""
}

variable "instance_type" {
  description = "The type of instance to launch"
  default     = "t2.micro"
}

variable "monitoring" {
  type        = "string"
  description = "Flag to enable detailed monitoring of the launched EC2 instance"
  default     = "false"
}

variable "environment" {
  type = "string"
  description = "The name of your environment"
}

variable "custom_tags" {
  type        = "map"
  default     = {}
  description = "map of tags to be added"
}

variable "subnet_tags" {
  description = "Pair of tags to filter subnet id"
  type        = "map"
}

variable "instance_count" {
  description = "Number of instances required"
}

variable "key_name" {
  description = "The key name of the Key Pair to use for the instance"
}

variable "associate_public_ip_address" {
  default = "false"
}

variable "associate_elastic_ip" {
  default = "false"
}

variable "disable_api_termination" {
  default = "true"
  description = "Enable EC2 Instance Termination Protection"
}

variable "iam_role" {
  default     = ""
  description = "The IAM Instance Profile to launch the instance with"
}

variable "attach_ebs_volume" {
  default = "true"
  description = "Flag to enable launch/attachmment of ebs volumes to EC2 instances"
}

variable "volume_type" {
  default = "gp2"
  description = "The type of EBS volume. Can be standard, gp2, io1, sc1 or st1"
}

variable "volume_size" {
  type    = "string"
  default = "100"
  description = "The size of the volumes in GiBs."
}

variable "ebs_iops" {
  type    = "string"
  default = "0"
  description = "The amount of IOPS to provision for the disk"
}

variable "device_name" {
  type    = "string"
  default = "/dev/xvdf"
  description = "The device name to expose to the instance (for example, /dev/sdh or xvdh)"
}

variable "ebs_optimized" {
  default = "true"
  description = "If true, the launched EC2 instance will be EBS-optimized"
}

variable "source_dest_check" {
  default = "true"
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs.Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs."
}

variable "kms_key_id" {
  default = ""
  description = "The ARN for the KMS encryption key to encrypt the volume"
}

variable "name" {
  type = "string"
  description = "Name of the resources getting launched"
}

variable "service" {
  type = "string"
  description = "Name of the service running on EC2 instances, eg: 'mysql', 'elasticsearch', 'kafka' etc. This is to attach a security group with 'service' tag to an instance the motive of applying similar rules for particular type of service at one place instead of redundant rules. Like if all mysql servers needs to connect S3 for backups, or they need to connect specific mysql monitoring tool"
}

variable "description" {
  type = "string"
  description = "description of security groups"
}

variable "security_rule_egress_cidr" {
  type        = "list"
  default = []

  description = <<EOF
Egress rules of security group where cidr_blocks to be defined. Following is the example and except description, all the fields are mandatory.

default = [
  {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = "0.0.0.0/0"
    description = ""
  }
]
EOF
}

variable "security_rule_ingress_cidr" {
  type        = "list"
  default = []

  description = <<EOF
Ingress rules of security group where cidr_blocks to be defined. Following is the example and except description, all the fields are mandatory.

default = [
  {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = "0.0.0.0/0"
    description = ""
  }
]
EOF
}

variable "security_rule_egress_self" {
  default     = []
  type        = "list"

  description = <<EOF
Egress rules of security group for self pointing. Following is the example and except description, all the fields are mandatory.

default = [
  {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    description = ""
  }
]
EOF
}

variable "security_rule_ingress_self" {
  default     = []
  type        = "list"

  description = <<EOF
Ingress rules of security group for self pointing. Following is the example and except description, all the fields are mandatory.

default = [
  {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    description = ""
  }
]
EOF
}

variable "security_rule_egress_groupid" {
  type        = "list"
  default     = []

  description = <<EOF
Egress rules of security group where source_security_group_id to be mapped. Following is the example and except description, all the fields are mandatory.

default = [
  {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    source_security_group_id = "sg-xc7gj8bj"
    description = ""
  }
]
EOF
}

variable "security_rule_ingress_groupid" {
  type        = "list"
  default     = []

  description = <<EOF
Ingress rules of security group where source_security_group_id to be mapped. Following is the example and except description, all the fields are mandatory.

default = [
  {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    source_security_group_id = "sg-xc7gj8bj"
    description = ""
  }
]
EOF
}
