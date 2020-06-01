provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.profile}"
  version = "~> 2.64"
}

/**
 *  Module to launch an Ec2 Instance
 */

resource "aws_instance" "instance" {
  ami                         = "${var.ami}"
  source_dest_check           = "${var.source_dest_check}"
  instance_type               = "${var.instance_type}"
  availability_zone           = "${element(var.availability_zones, count.index)}"
  subnet_id                   = "${data.aws_subnet.subnet.*.id[count.index % length(var.availability_zones)]}"
  vpc_security_group_ids      = ["${aws_security_group.sg.id}","${data.aws_security_group.common-sg.id}","${data.aws_security_group.service-sg.id}"]
  monitoring                  = "${var.monitoring}"
  tenancy                     = "default"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  disable_api_termination     = "${var.disable_api_termination}"
  iam_instance_profile        = "${var.iam_role}"
  user_data                   = "${var.user_data}"
  ebs_optimized               = "${replace(var.instance_type, "/^[^t2].*/", "1") == 1 && var.ebs_optimized == "true" ? true : false}"
  count                       = "${var.instance_count}"

  tags = "${merge(
    map("Name", "${format("%s-%s-%02d", var.environment, var.name, count.index+1)}"),
    map("environment", "${var.environment}"),
    map("datacenter","${var.aws_region}"),
    var.custom_tags)
  }"
}

resource "aws_eip" "eip" {
  vpc   = true
  instance = "${aws_instance.instance.*.id[count.index]}"
  count = "${var.associate_elastic_ip == "true" && var.associate_elastic_ip == "true" ? var.instance_count : 0}"

  tags = "${merge(
    map("environment", "${var.environment}"),
    var.custom_tags)
  }"
}
