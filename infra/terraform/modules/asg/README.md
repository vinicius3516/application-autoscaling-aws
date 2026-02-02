# AWS Auto Scaling Group Module

This Terraform module provisions an AWS Launch Template and Auto Scaling Group (ASG) with optional CPU-based scaling policies and CloudWatch alarms.

## Architecture Overview

```
                    ┌─────────────────────────────────────────────────────────────┐
                    │                      AWS Cloud                              │
                    │                                                             │
                    │  ┌──────────────────────────────────────────────────────┐   │
                    │  │                  Auto Scaling Group                   │   │
                    │  │                                                       │   │
                    │  │   ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │   │
                    │  │   │  Instance   │  │  Instance   │  │  Instance   │  │   │
                    │  │   │   (AZ-a)    │  │   (AZ-b)    │  │   (AZ-c)    │  │   │
                    │  │   └─────────────┘  └─────────────┘  └─────────────┘  │   │
                    │  │          ▲                ▲                ▲         │   │
                    │  │          │                │                │         │   │
                    │  │          └────────────────┼────────────────┘         │   │
                    │  │                           │                          │   │
                    │  │               ┌───────────┴───────────┐              │   │
                    │  │               │   Launch Template     │              │   │
                    │  │               │  ┌─────────────────┐  │              │   │
                    │  │               │  │ AMI             │  │              │   │
                    │  │               │  │ Instance Type   │  │              │   │
                    │  │               │  │ Security Groups │  │              │   │
                    │  │               │  │ User Data       │  │              │   │
                    │  │               │  │ Block Devices   │  │              │   │
                    │  │               │  └─────────────────┘  │              │   │
                    │  │               └───────────────────────┘              │   │
                    │  │                                                       │   │
                    │  └───────────────────────────┬───────────────────────────┘   │
                    │                              │                               │
                    │              ┌───────────────┴───────────────┐               │
                    │              │      Scaling Policies         │               │
                    │              │   (Optional CPU-based)        │               │
                    │              │                               │               │
                    │              │  ┌─────────┐    ┌─────────┐   │               │
                    │              │  │Scale Up │    │Scale    │   │               │
                    │              │  │ Policy  │    │Down     │   │               │
                    │              │  └────┬────┘    │Policy   │   │               │
                    │              │       │         └────┬────┘   │               │
                    │              └───────┼──────────────┼────────┘               │
                    │                      │              │                        │
                    │              ┌───────┴──────────────┴────────┐               │
                    │              │     CloudWatch Alarms         │               │
                    │              │  ┌──────────┐  ┌──────────┐   │               │
                    │              │  │ CPU High │  │ CPU Low  │   │               │
                    │              │  │  Alarm   │  │  Alarm   │   │               │
                    │              │  └──────────┘  └──────────┘   │               │
                    │              └───────────────────────────────┘               │
                    │                                                              │
                    └──────────────────────────────────────────────────────────────┘
```

## Features

- **Launch Template**: Configurable EC2 launch template with support for:
  - Custom or auto-discovered AMI (defaults to Ubuntu 22.04)
  - Instance type configuration
  - Security groups and SSH key pairs
  - User data scripts
  - EBS volume configuration with encryption
  - IAM instance profiles
  - IMDSv2 enforcement
  - Detailed monitoring

- **Auto Scaling Group**: Fully configurable ASG with:
  - Multi-AZ deployment across specified subnets
  - Health check configuration (EC2 or ELB)
  - Target group integration for load balancers
  - Instance refresh for rolling updates
  - Customizable termination policies

- **Scaling Policies** (Optional): CPU-based auto scaling with:
  - Scale up policy triggered by high CPU utilization
  - Scale down policy triggered by low CPU utilization
  - CloudWatch alarms for metric monitoring

## Usage

### Basic Example

```hcl
module "asg" {
  source = "./modules/asg"

  name       = "my-app"
  subnet_ids = ["subnet-abc123", "subnet-def456"]

  instance_type      = "t3.small"
  security_group_ids = [aws_security_group.app.id]

  min_size         = 1
  max_size         = 5
  desired_capacity = 2

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

### With Load Balancer Integration

```hcl
module "asg" {
  source = "./modules/asg"

  name       = "web-app"
  subnet_ids = var.private_subnet_ids

  instance_type            = "t3.medium"
  security_group_ids       = [aws_security_group.web.id]
  iam_instance_profile_arn = aws_iam_instance_profile.web.arn
  key_name                 = "my-key"

  user_data_base64 = base64encode(file("${path.module}/userdata.sh"))

  min_size         = 2
  max_size         = 10
  desired_capacity = 3

  health_check_type         = "ELB"
  health_check_grace_period = 300
  target_group_arns         = [aws_lb_target_group.web.arn]

  enable_instance_refresh              = true
  instance_refresh_min_healthy_percentage = 75

  tags = {
    Environment = "production"
  }
}
```

### With Scaling Policies

```hcl
module "asg" {
  source = "./modules/asg"

  name       = "api-server"
  subnet_ids = var.private_subnet_ids

  instance_type      = "t3.large"
  security_group_ids = [aws_security_group.api.id]

  min_size         = 2
  max_size         = 20
  desired_capacity = 4

  enable_scaling_policies = true
  cpu_high_threshold      = 70
  cpu_low_threshold       = 30
  scale_up_adjustment     = 2
  scale_down_adjustment   = -1

  tags = {
    Environment = "production"
  }
}
```

### With Custom AMI

```hcl
module "asg" {
  source = "./modules/asg"

  name       = "custom-app"
  subnet_ids = var.subnet_ids

  ami_id        = "ami-0123456789abcdef0"
  instance_type = "t3.medium"

  min_size         = 1
  max_size         = 5
  desired_capacity = 2

  tags = {
    Environment = "staging"
  }
}
```

## Requirements

| Name      | Version  |
|-----------|----------|
| terraform | >= 1.0   |
| aws       | >= 4.0   |

## Inputs

### General

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Base name for all resources | `string` | n/a | yes |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |

### Launch Template

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| launch_template_name | Custom name for the launch template | `string` | `null` | no |
| launch_template_description | Description for the launch template | `string` | `"Managed by Terraform"` | no |
| ami_id | AMI ID to use | `string` | `null` | no |
| ami_filter_name | AMI name filter pattern | `string` | `"ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"` | no |
| ami_owners | List of AMI owners | `list(string)` | `["099720109477"]` | no |
| instance_type | EC2 instance type | `string` | `"t3.micro"` | no |
| key_name | SSH key pair name | `string` | `null` | no |
| security_group_ids | List of security group IDs | `list(string)` | `[]` | no |
| user_data_base64 | Base64-encoded user data script | `string` | `null` | no |
| ebs_optimized | Enable EBS optimization | `bool` | `true` | no |
| iam_instance_profile_arn | IAM instance profile ARN | `string` | `null` | no |
| enable_monitoring | Enable detailed monitoring | `bool` | `true` | no |
| block_device_mappings | List of block device mappings | `list(object)` | See variables.tf | no |
| metadata_http_tokens | IMDSv2 configuration | `string` | `"required"` | no |

### Auto Scaling Group

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| asg_name | Custom name for the ASG | `string` | `null` | no |
| subnet_ids | List of subnet IDs | `list(string)` | n/a | yes |
| min_size | Minimum number of instances | `number` | `1` | no |
| max_size | Maximum number of instances | `number` | `3` | no |
| desired_capacity | Desired number of instances | `number` | `1` | no |
| health_check_type | Health check type: EC2 or ELB | `string` | `"EC2"` | no |
| health_check_grace_period | Health check grace period (seconds) | `number` | `300` | no |
| target_group_arns | List of target group ARNs | `list(string)` | `[]` | no |
| termination_policies | List of termination policies | `list(string)` | `["Default"]` | no |
| enable_instance_refresh | Enable instance refresh | `bool` | `false` | no |
| launch_template_version | Launch template version | `string` | `"$Latest"` | no |

### Scaling Policies

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_scaling_policies | Enable CPU-based scaling policies | `bool` | `false` | no |
| scale_up_adjustment | Instances to add on scale up | `number` | `1` | no |
| scale_down_adjustment | Instances to remove on scale down | `number` | `-1` | no |
| cpu_high_threshold | CPU % to trigger scale up | `number` | `80` | no |
| cpu_low_threshold | CPU % to trigger scale down | `number` | `20` | no |

## Outputs

| Name | Description |
|------|-------------|
| launch_template_id | ID of the launch template |
| launch_template_arn | ARN of the launch template |
| launch_template_name | Name of the launch template |
| launch_template_latest_version | Latest version of the launch template |
| asg_id | ID of the Auto Scaling Group |
| asg_arn | ARN of the Auto Scaling Group |
| asg_name | Name of the Auto Scaling Group |
| asg_availability_zones | Availability zones of the ASG |
| scale_up_policy_arn | ARN of the scale up policy |
| scale_down_policy_arn | ARN of the scale down policy |
| ami_id | AMI ID used by the launch template |

## Security Considerations

- **IMDSv2**: The module enforces IMDSv2 by default (`metadata_http_tokens = "required"`)
- **EBS Encryption**: Root volumes are encrypted by default
- **Detailed Monitoring**: Enabled by default for better observability
- **Security Groups**: Must be explicitly provided; no default ingress rules

## License

MIT
