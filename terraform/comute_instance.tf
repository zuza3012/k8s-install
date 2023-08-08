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


# Create workers
resource "openstack_compute_instance_v2" "workers" {
  name = "${format("worker%d", count.index + 1)}"
  count = var.inst_count
  image_id = data.openstack_images_image_v2.ubuntu.id
  flavor_name = "c.4VCPU_4GB"
  network {
    name = openstack_networking_network_v2.ktest.name
  }
  key_pair = var.key_pair
  security_groups = [openstack_networking_secgroup_v2.sec_ssh_grp.name, openstack_networking_secgroup_v2.worker.name, openstack_networking_secgroup_v2.icmp_allow.name]
}

# Create master
resource "openstack_compute_instance_v2" "masters" {
  name = "${format("master%d", count.index + 1)}"
  count = var.master_count
  image_id = data.openstack_images_image_v2.ubuntu.id
  flavor_name = "c.4VCPU_4GB"
  network {
    name = openstack_networking_network_v2.ktest.name
  }
  key_pair = var.key_pair
  security_groups = [openstack_networking_secgroup_v2.sec_ssh_grp.name, openstack_networking_secgroup_v2.master.name, openstack_networking_secgroup_v2.icmp_allow.name]
}
# floating ip workers
resource "openstack_compute_floatingip_associate_v2" "workers_ips" {
  count = var.inst_count
  floating_ip = openstack_networking_floatingip_v2.worker[count.index].address
  instance_id = openstack_compute_instance_v2.workers[count.index].id
}

# floating ip masters
resource "openstack_compute_floatingip_associate_v2" "masters_ips" {
  count = var.master_count
  floating_ip = openstack_networking_floatingip_v2.master[count.index].address
  instance_id = openstack_compute_instance_v2.masters[count.index].id
}

# floating ip c for connect
resource "openstack_compute_floatingip_associate_v2" "connect_ip" {
  floating_ip = openstack_networking_floatingip_v2.connect.address
  instance_id = openstack_compute_instance_v2.connect.id
}
