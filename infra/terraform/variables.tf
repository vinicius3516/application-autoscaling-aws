variable "environment" {
  type    = string
  default = "staging"
  validation {
    condition     = contains(["staging", "prod"], var.environment)
    error_message = "The environment must be one of 'staging', or 'prod'."
  }
}
variable "vpc_az" {
  type    = string
  default = "main"
}