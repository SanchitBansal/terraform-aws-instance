/**
 *  Module to create ebs volumes and attach to EC2 instances launched
 */

resource "aws_ebs_volume" "ebs" {
  availability_zone = "${element(var.availability_zones, count.index)}"
  type              = "${var.volume_type}"
  size              = "${var.volume_size}"
  iops              = "${var.volume_type == "io1" ? var.ebs_iops : 0}"
  encrypted        = "${length(var.kms_key_id) > 0 ? "true" : "false"}"
  kms_key_id        = "${var.kms_key_id}"
  count             = "${var.attach_ebs_volume ? var.instance_count : 0}"

  tags = "${merge(
    map("Name", "${format("%s-%s-%02d", var.environment, var.name, count.index+1)}"),
    map("environment", "${var.environment}"),
    map("datacenter","${var.aws_region}"),
    var.custom_tags)
  }"
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "${var.device_name}"
  volume_id   = "${aws_ebs_volume.ebs.*.id[count.index]}"
  instance_id = "${aws_instance.instance.*.id[count.index]}"
  count       = "${var.attach_ebs_volume ? var.instance_count : 0}"
}
