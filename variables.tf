variable "vpc_security_group_id" {
  description = "Security group ID allowing SSH"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to launch EC2"
  type        = string
}
