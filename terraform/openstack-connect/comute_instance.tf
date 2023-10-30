# connection vm
resource "openstack_compute_instance_v2" "connect" {
  name = "connect"
  image_id = data.openstack_images_image_v2.ubuntu.id
  flavor_name = "c.4VCPU_4GB"
  network {
    name = openstack_networking_network_v2.ktest.name
  }
  key_pair = var.key_pair
  security_groups = [openstack_networking_secgroup_v2.sec_ssh_grp.name, openstack_networking_secgroup_v2.icmp_allow.name]
}

# floating ip c for connect
resource "openstack_compute_floatingip_associate_v2" "connect_ip" {
  floating_ip = openstack_networking_floatingip_v2.connect.address
  instance_id = openstack_compute_instance_v2.connect.id
}
