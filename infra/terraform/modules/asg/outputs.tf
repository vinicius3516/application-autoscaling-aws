# ------------------------------------------------------------------------------
# Launch Template Outputs
# ------------------------------------------------------------------------------

output "launch_template_id" {
  description = "ID of the launch template"
  value       = aws_launch_template.this.id
}

output "launch_template_arn" {
  description = "ARN of the launch template"
  value       = aws_launch_template.this.arn
}

output "launch_template_name" {
  description = "Name of the launch template"
  value       = aws_launch_template.this.name
}

output "launch_template_latest_version" {
  description = "Latest version of the launch template"
  value       = aws_launch_template.this.latest_version
}

# ------------------------------------------------------------------------------
# Auto Scaling Group Outputs
# ------------------------------------------------------------------------------

output "asg_id" {
  description = "ID of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.id
}

output "asg_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.arn
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.name
}

output "asg_availability_zones" {
  description = "Availability zones of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.availability_zones
}

# ------------------------------------------------------------------------------
# Scaling Policy Outputs
# ------------------------------------------------------------------------------

output "scale_up_policy_arn" {
  description = "ARN of the scale up policy"
  value       = var.enable_scaling_policies ? aws_autoscaling_policy.scale_up[0].arn : null
}

output "scale_down_policy_arn" {
  description = "ARN of the scale down policy"
  value       = var.enable_scaling_policies ? aws_autoscaling_policy.scale_down[0].arn : null
}

# ------------------------------------------------------------------------------
# AMI Output
# ------------------------------------------------------------------------------

output "ami_id" {
  description = "AMI ID used by the launch template"
  value       = var.ami_id != null ? var.ami_id : data.aws_ami.this.id
}
