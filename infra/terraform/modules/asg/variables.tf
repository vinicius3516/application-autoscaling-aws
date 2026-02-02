variable "name" {
  description = "Base name for all resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# ------------------------------------------------------------------------------
# Launch Template
# ------------------------------------------------------------------------------

variable "launch_template_name" {
  description = "Custom name for the launch template. If not set, uses name-lt"
  type        = string
  default     = null
}

variable "launch_template_description" {
  description = "Description for the launch template"
  type        = string
  default     = "Managed by Terraform"
}

variable "ami_id" {
  description = "AMI ID to use. If not set, uses the latest AMI matching ami_filter_name"
  type        = string
  default     = null
}

variable "ami_filter_name" {
  description = "AMI name filter pattern for data source lookup"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "ami_owners" {
  description = "List of AMI owners for data source lookup"
  type        = list(string)
  default     = ["099720109477"] # Canonical
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "List of security group IDs for instances"
  type        = list(string)
  default     = []
}

variable "user_data_base64" {
  description = "Base64-encoded user data script"
  type        = string
  default     = null
}

variable "ebs_optimized" {
  description = "Enable EBS optimization"
  type        = bool
  default     = true
}

variable "iam_instance_profile_arn" {
  description = "IAM instance profile ARN"
  type        = string
  default     = null
}

variable "enable_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = true
}

variable "block_device_mappings" {
  description = "List of block device mappings"
  type = list(object({
    device_name           = string
    volume_size           = number
    volume_type           = string
    delete_on_termination = bool
    encrypted             = bool
  }))
  default = [{
    device_name           = "/dev/sda1"
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }]
}

variable "metadata_http_tokens" {
  description = "IMDSv2 configuration: required or optional"
  type        = string
  default     = "required"
}

variable "metadata_http_put_response_hop_limit" {
  description = "HTTP PUT response hop limit for instance metadata"
  type        = number
  default     = 1
}

# ------------------------------------------------------------------------------
# Auto Scaling Group
# ------------------------------------------------------------------------------

variable "asg_name" {
  description = "Custom name for the ASG. If not set, uses name-asg"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ASG"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 1
}

variable "health_check_type" {
  description = "Health check type: EC2 or ELB"
  type        = string
  default     = "EC2"
}

variable "health_check_grace_period" {
  description = "Health check grace period in seconds"
  type        = number
  default     = 300
}

variable "target_group_arns" {
  description = "List of target group ARNs for load balancer integration"
  type        = list(string)
  default     = []
}

variable "termination_policies" {
  description = "List of termination policies"
  type        = list(string)
  default     = ["Default"]
}

variable "suspended_processes" {
  description = "List of processes to suspend"
  type        = list(string)
  default     = []
}

variable "default_cooldown" {
  description = "Default cooldown period in seconds"
  type        = number
  default     = 300
}

variable "wait_for_capacity_timeout" {
  description = "Timeout for waiting for capacity"
  type        = string
  default     = "10m"
}

variable "launch_template_version" {
  description = "Launch template version to use"
  type        = string
  default     = "$Latest"
}

variable "enable_instance_refresh" {
  description = "Enable instance refresh for rolling updates"
  type        = bool
  default     = false
}

variable "instance_refresh_min_healthy_percentage" {
  description = "Minimum healthy percentage during instance refresh"
  type        = number
  default     = 50
}

# ------------------------------------------------------------------------------
# Scaling Policies
# ------------------------------------------------------------------------------

variable "enable_scaling_policies" {
  description = "Enable CPU-based scaling policies and alarms"
  type        = bool
  default     = false
}

variable "scale_up_adjustment" {
  description = "Number of instances to add when scaling up"
  type        = number
  default     = 1
}

variable "scale_up_cooldown" {
  description = "Cooldown period after scale up in seconds"
  type        = number
  default     = 300
}

variable "scale_down_adjustment" {
  description = "Number of instances to remove when scaling down (use negative value)"
  type        = number
  default     = -1
}

variable "scale_down_cooldown" {
  description = "Cooldown period after scale down in seconds"
  type        = number
  default     = 300
}

variable "cpu_high_threshold" {
  description = "CPU threshold percentage to trigger scale up"
  type        = number
  default     = 80
}

variable "cpu_low_threshold" {
  description = "CPU threshold percentage to trigger scale down"
  type        = number
  default     = 20
}

variable "cpu_alarm_evaluation_periods" {
  description = "Number of periods to evaluate for CPU alarms"
  type        = number
  default     = 2
}

variable "cpu_alarm_period" {
  description = "Period in seconds for CPU alarm evaluation"
  type        = number
  default     = 120
}
