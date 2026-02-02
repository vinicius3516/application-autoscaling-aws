data "aws_ami" "this" {
  most_recent = true
  owners      = var.ami_owners

  filter {
    name   = "name"
    values = [var.ami_filter_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "this" {
  name        = var.launch_template_name != null ? var.launch_template_name : "${var.name}-lt"
  description = var.launch_template_description

  image_id               = var.ami_id != null ? var.ami_id : data.aws_ami.this.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids
  user_data              = var.user_data_base64

  ebs_optimized = var.ebs_optimized

  dynamic "iam_instance_profile" {
    for_each = var.iam_instance_profile_arn != null ? [1] : []
    content {
      arn = var.iam_instance_profile_arn
    }
  }

  monitoring {
    enabled = var.enable_monitoring
  }

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    content {
      device_name = block_device_mappings.value.device_name

      ebs {
        volume_size           = block_device_mappings.value.volume_size
        volume_type           = block_device_mappings.value.volume_type
        delete_on_termination = block_device_mappings.value.delete_on_termination
        encrypted             = block_device_mappings.value.encrypted
      }
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = var.metadata_http_tokens
    http_put_response_hop_limit = var.metadata_http_put_response_hop_limit
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge(var.tags, { Name = var.name })
  }

  tag_specifications {
    resource_type = "volume"
    tags          = merge(var.tags, { Name = var.name })
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name                = var.asg_name != null ? var.asg_name : "${var.name}-asg"
  vpc_zone_identifier = var.subnet_ids
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity

  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  target_group_arns         = var.target_group_arns
  termination_policies      = var.termination_policies
  suspended_processes       = var.suspended_processes

  default_cooldown          = var.default_cooldown
  wait_for_capacity_timeout = var.wait_for_capacity_timeout

  launch_template {
    id      = aws_launch_template.this.id
    version = var.launch_template_version
  }

  dynamic "instance_refresh" {
    for_each = var.enable_instance_refresh ? [1] : []
    content {
      strategy = "Rolling"
      preferences {
        min_healthy_percentage = var.instance_refresh_min_healthy_percentage
      }
    }
  }

  dynamic "tag" {
    for_each = merge(var.tags, { Name = var.name })
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  count = var.enable_scaling_policies ? 1 : 0

  name                   = "${var.name}-scale-up"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = var.scale_up_adjustment
  cooldown               = var.scale_up_cooldown
  policy_type            = "SimpleScaling"
}

resource "aws_autoscaling_policy" "scale_down" {
  count = var.enable_scaling_policies ? 1 : 0

  name                   = "${var.name}-scale-down"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = var.scale_down_adjustment
  cooldown               = var.scale_down_cooldown
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  count = var.enable_scaling_policies ? 1 : 0

  alarm_name          = "${var.name}-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.cpu_alarm_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.cpu_alarm_period
  statistic           = "Average"
  threshold           = var.cpu_high_threshold

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_up[0].arn]

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  count = var.enable_scaling_policies ? 1 : 0

  alarm_name          = "${var.name}-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.cpu_alarm_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.cpu_alarm_period
  statistic           = "Average"
  threshold           = var.cpu_low_threshold

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_down[0].arn]

  tags = var.tags
}
