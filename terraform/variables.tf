variable "os_username" {
  description = "Openstack username"
  type        = string
  sensitive   = true
  #default = "zuzanna.wieczorek"
}
variable "os_project_name" {
  description = "Openstack project"
  type        = string
  sensitive   = true
  #default     = "HPCaaS terraform dev"
}
variable "os_password_input" {
  description = "Openstack password"
  type        = string
  sensitive   = true
}
variable "os_auth_url" {
  description = "Openstack url"
  type        = string
  sensitive   = true
  #default = "https://api.cloud.psnc.pl:5000"
}
variable "os_region_name" {
  description = "Openstack username"
  type        = string
  sensitive   = true
  #default     = "BST"
}
variable "master_count" {
  description = "Number of instances"
  type        = number
  default     = 1
}

variable "inst_count" {
  description = "Number of instances"
  type        = number
  default     = 2
}

variable "terraform_user" {
  description = "User running terraform"
  type        = string
  default     = "zuzanna"
}

variable "key_pair" {
  description = "Key pair available in openstack for ssh"
  type        = string
  sensitive   = true
 #default     = "openstack_poznan"
}


## for ansible inventory
# variable "docker_hpcaas_product_1" {
#   description = "docker_hpcaas_product_1 host ip"
#   type        = string
#   default     = "62.3.171.234"
# }

# variable "docker_registry" {
#   description = "docker_registry host ip"
#   type        = string
#   default     = "62.3.170.117"
# }
