resource "aws_launch_configuration" "web" {
  name_prefix = "web"
  image_id = "ami-0947d2ba12ee1ff75"
  instance_type = "t2.medium"
  key_name = "${aws_key_pair.mykey.key_name}"
  security_groups = ["${aws_security_group.allow-ssh.id}"]
}

resource "aws_autoscaling_group" "web" {
  name = "web"
  vpc_zone_identifier = "${aws_subnet.private.id}"
  launch_configuration = "${aws_launch_configuration.web.name}"
  min_size = 2
  max_size = 5
  health_check_grace_period = 300
  health_check_type = "EC2"
  force_delete = true
  tag {
    key = "Name"
    value = "web
    propagate_at_launch = true
  }
}
