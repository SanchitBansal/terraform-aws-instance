## Resource to create security group of EC2 instances created

resource "aws_security_group" "sg" {
  name        = "${format("%s-sg-%s", var.environment, var.name)}"
  description = "${var.description}"
  vpc_id      = "${data.aws_subnet.subnet.0.vpc_id}"

  tags = "${merge(
    map("Name", "${format("%s-sg-%s", var.environment, var.name)}"),
    map("environment", "${var.environment}"),
    var.custom_tags)
  }"
}

## Ingress rules of EC2 security group with cidr_blocks
resource "aws_security_group_rule" "ingress_cidr" {
  type              = "ingress"
  from_port         = "${lookup(var.security_rule_ingress_cidr[count.index], "from_port")}"
  to_port           = "${lookup(var.security_rule_ingress_cidr[count.index], "to_port")}"
  protocol          = "${lookup(var.security_rule_ingress_cidr[count.index], "protocol")}"
  cidr_blocks       = ["${split("," , lookup(var.security_rule_ingress_cidr[count.index], "cidr_blocks"))}"]
  description       = "${lookup(var.security_rule_ingress_cidr[count.index], "description", "Ingress rule")}"
  security_group_id = "${aws_security_group.sg.id}"
  count             = "${length(var.security_rule_ingress_cidr)}"
}

## Ingress rules of EC2 security group with self
resource "aws_security_group_rule" "ingress_self" {
  type              = "ingress"
  from_port         = "${lookup(var.security_rule_ingress_self[count.index], "from_port")}"
  to_port           = "${lookup(var.security_rule_ingress_self[count.index], "to_port")}"
  protocol          = "${lookup(var.security_rule_ingress_self[count.index], "protocol")}"
  self              = true
  description       = "${lookup(var.security_rule_ingress_self[count.index], "description", "Ingress rule")}"
  security_group_id = "${aws_security_group.sg.id}"
  count             = "${length(var.security_rule_ingress_self)}"
}

## Ingress rules of EC2 security group with source_security_group_id
resource "aws_security_group_rule" "ingress_groupid" {
  type                     = "ingress"
  from_port                = "${lookup(var.security_rule_ingress_groupid[count.index], "from_port")}"
  to_port                  = "${lookup(var.security_rule_ingress_groupid[count.index], "to_port")}"
  protocol                 = "${lookup(var.security_rule_ingress_groupid[count.index], "protocol")}"
  source_security_group_id = "${lookup(var.security_rule_ingress_groupid[count.index], "source_security_group_id")}"
  description              = "${lookup(var.security_rule_ingress_groupid[count.index], "description", "Ingress rule")}"
  security_group_id        = "${aws_security_group.sg.id}"
  count                    = "${length(var.security_rule_ingress_groupid)}"
}

## Egress rules of EC2 security group with cidr_blocks
resource "aws_security_group_rule" "egress_cidr" {
  type                     = "egress"
  from_port                = "${lookup(var.security_rule_egress_cidr[count.index], "from_port")}"
  to_port                  = "${lookup(var.security_rule_egress_cidr[count.index], "to_port")}"
  protocol                 = "${lookup(var.security_rule_egress_cidr[count.index], "protocol")}"
  cidr_blocks              = ["${split("," , lookup(var.security_rule_egress_cidr[count.index], "cidr_blocks"))}"]
  description              = "${lookup(var.security_rule_egress_cidr[count.index], "description", "Egress rule")}"
  security_group_id        = "${aws_security_group.sg.id}"
  count                    = "${length(var.security_rule_egress_cidr)}"
}

## Egress rules of EC2 security group with self
resource "aws_security_group_rule" "egress_self" {
  type                     = "egress"
  from_port                = "${lookup(var.security_rule_egress_self[count.index], "from_port")}"
  to_port                  = "${lookup(var.security_rule_egress_self[count.index], "to_port")}"
  protocol                 = "${lookup(var.security_rule_egress_self[count.index], "protocol")}"
  self                     = true
  description              = "${lookup(var.security_rule_egress_self[count.index], "description", "Egress rule")}"
  security_group_id        = "${aws_security_group.sg.id}"
  count                    = "${length(var.security_rule_egress_self)}"
}

## Egress rules of EC2 security group with source_security_group_id
resource "aws_security_group_rule" "egress_groupid" {
  type                     = "egress"
  from_port                = "${lookup(var.security_rule_egress_groupid[count.index], "from_port")}"
  to_port                  = "${lookup(var.security_rule_egress_groupid[count.index], "to_port")}"
  protocol                 = "${lookup(var.security_rule_egress_groupid[count.index], "protocol")}"
  source_security_group_id = "${lookup(var.security_rule_egress_groupid[count.index], "source_security_group_id")}"
  description              = "${lookup(var.security_rule_egress_groupid[count.index], "description", "Egress rule")}"
  security_group_id        = "${aws_security_group.sg.id}"
  count                    = "${length(var.security_rule_egress_groupid)}"
}
