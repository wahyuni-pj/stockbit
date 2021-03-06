# scale up alarm
resource "aws_autoscaling_policy" "cpu" {
  name = "cpu"
  autoscaling_group_name = "${aws_autoscaling_group.web.name}"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "1"
  cooldown = "300"
  policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu-alarm" {
  alarm_name = "cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "45"
  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.web.name}"
  }
  actions_enabled = true
  alarm_actions = ["${aws_autoscaling_policy.cpu.arn}"]
}
