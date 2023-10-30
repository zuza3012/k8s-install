variable "vpc_network" {
  description = "VPC network"
  type        = string
  default = "10.10.0.0/24"
}
variable "public_subnet" {
  description = "Public subnet ip address"
  type        = string
  default     = "10.10.0.0/26"
}

variable "aws_keypair" {
  description = "Key pair for connecting to EC2"
  type        = string
	default 		= "/home/zuzanna/.ssh/aws-example1.pub" #"/home/zuzanna/.ssh/aws-example1.pub"
}
