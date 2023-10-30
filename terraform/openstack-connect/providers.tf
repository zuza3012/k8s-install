# source RC file before terraform init
# Define required providers
terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
       version = "~> 1.51.1"
    }
    ansible = {
      version = "~> 1.1.0"
      source  = "ansible/ansible"
    }
  }
}


# Configure the OpenStack Provider
provider "openstack" {
  user_name   = var.os_username
	tenant_name = var.os_project_name
  password    = var.os_password_input
  auth_url    = var.os_auth_url	
  region      = var.os_region_name
}
