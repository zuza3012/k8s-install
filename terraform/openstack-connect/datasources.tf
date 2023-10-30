data "openstack_networking_network_v2" "ext_network" {
  name = "PCSS-BST-PUB2-EDU"
}

data "openstack_images_image_v2" "ubuntu" {
  name        = "Ubuntu Server 22.04 LTS Cloud Image"
  most_recent = true

  properties = {
    key = "value"
  }
}
