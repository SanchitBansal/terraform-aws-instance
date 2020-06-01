/**
 * data source to get subnets of paricular tags and availability_zones
 */

data "aws_subnet" "subnet" {
  tags = "${merge(
    map("environment", "${var.environment}"),
    var.subnet_tags)
  }"
  availability_zone = "${element(var.availability_zones,count.index)}"
  count = "${length(var.availability_zones)}"
}

/**
 * Security group having common rules which are required for all the instances. This is a separate security group created for this purpose only to avoid repetated rules.
 * This should return just single security group so keep in mind the tags to be applied to security group
 */

data "aws_security_group" "common-sg" {
  filter {
    name   = "tag:service"
    values = ["common"]
  }

  filter {
    name   = "tag:environment"
    values = ["${var.environment}"]
  }
}

/**
 * Security group having common rules for particular service type like "mysql", "elasticsearch", "kafka", "mongodb". This is a separate security group created at service level to avoid redundant rules.
 * This should return just single security group so keep in mind the tags to be applied to security group
 */

data "aws_security_group" "service-sg" {
  filter {
    name   = "tag:service"
    values = ["${var.service}"]
  }

  filter {
    name   = "tag:environment"
    values = ["${var.environment}"]
  }

}
