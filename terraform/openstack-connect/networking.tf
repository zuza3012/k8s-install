resource "openstack_networking_network_v2" "ktest" {
  name           = "ktest"
  admin_state_up = "true"
}


resource "openstack_networking_subnet_v2" "ktest" {
  name            = "ktest"
  network_id      = openstack_networking_network_v2.ktest.id
  cidr            = "192.168.0.0/24"
  ip_version      = 4
}

resource "openstack_networking_router_v2" "ktest" {
  name                = "ktest"
  admin_state_up      = "true"
  external_network_id = data.openstack_networking_network_v2.ext_network.id
}

resource "openstack_networking_router_interface_v2" "ktest" {
  router_id = "${openstack_networking_router_v2.ktest.id}"
  subnet_id = "${openstack_networking_subnet_v2.ktest.id}"
}


# float ips for master for debugging only
resource "openstack_networking_floatingip_v2" "connect" {
  pool = data.openstack_networking_network_v2.ext_network.name
  description = "ktest"
}
# security group for SSH connection with outside world (for debugging)
# change it in the future!

resource "openstack_networking_secgroup_v2" "sec_ssh_grp" {
  name        = "ktest_ssh"
  description = "Enable ssh"
}

resource "openstack_networking_secgroup_rule_v2" "sec_ssh_grp_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sec_ssh_grp.id
}

resource "openstack_networking_secgroup_v2" "icmp_allow" {
  name        = "icmp_allow"
  description = "ktest rules"
}

resource "openstack_networking_secgroup_rule_v2" "icmp_allow_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = openstack_networking_subnet_v2.ktest.cidr
  security_group_id = openstack_networking_secgroup_v2.icmp_allow.id
}
