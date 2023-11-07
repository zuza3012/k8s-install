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

# float ips for instances for debugging only
resource "openstack_networking_floatingip_v2" "worker" {
  count = var.inst_count
  pool = data.openstack_networking_network_v2.ext_network.name
  description = "ktest"
}

# float ips for master for debugging only
resource "openstack_networking_floatingip_v2" "master" {
  count = var.master_count
  pool = data.openstack_networking_network_v2.ext_network.name
  description = "ktest"
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

# add open ports for master
resource "openstack_networking_secgroup_v2" "master" {
  name        = "master"
  description = "ktest rules"
}
####################### master ingress #######################

resource "openstack_networking_secgroup_rule_v2" "master-api-ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_ip_prefix  = openstack_networking_subnet_v2.ktest.cidr
  security_group_id = openstack_networking_secgroup_v2.master.id
}

resource "openstack_networking_secgroup_rule_v2" "master-etcd-ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 2379
  port_range_max    = 2380
  remote_ip_prefix  = openstack_networking_subnet_v2.ktest.cidr
  security_group_id = openstack_networking_secgroup_v2.master.id
}

resource "openstack_networking_secgroup_rule_v2" "master-kubelet-ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10250
  port_range_max    = 10250
  remote_ip_prefix  = openstack_networking_subnet_v2.ktest.cidr
  security_group_id = openstack_networking_secgroup_v2.master.id
}

resource "openstack_networking_secgroup_rule_v2" "master-scheduler-ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10259
  port_range_max    = 10259
  remote_ip_prefix  = openstack_networking_subnet_v2.ktest.cidr
  security_group_id = openstack_networking_secgroup_v2.master.id
}

resource "openstack_networking_secgroup_rule_v2" "master-controller-ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10257
  port_range_max    = 10257
  remote_ip_prefix  = openstack_networking_subnet_v2.ktest.cidr
  security_group_id = openstack_networking_secgroup_v2.master.id
}

resource "openstack_networking_secgroup_rule_v2" "master-calico-ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 179
  port_range_max    = 179
  remote_ip_prefix  = openstack_networking_subnet_v2.ktest.cidr
  security_group_id = openstack_networking_secgroup_v2.master.id
}
####################### end of master ingress #######################

####################### master egres #######################
resource "openstack_networking_secgroup_rule_v2" "master-api-egress" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_ip_prefix  = openstack_networking_subnet_v2.ktest.cidr
  security_group_id = openstack_networking_secgroup_v2.master.id
}


resource "openstack_networking_secgroup_rule_v2" "master-kubelet-egress" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10250
  port_range_max    = 10250
  remote_ip_prefix  = openstack_networking_subnet_v2.ktest.cidr
  security_group_id = openstack_networking_secgroup_v2.master.id
}

resource "openstack_networking_secgroup_rule_v2" "master-calico-egress" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 179
  port_range_max    = 179
  remote_ip_prefix  = openstack_networking_subnet_v2.ktest.cidr
  security_group_id = openstack_networking_secgroup_v2.master.id
}
####################### end of master egres #######################
# add open ports for workers
resource "openstack_networking_secgroup_v2" "worker" {
  name        = "worker"
  description = "ktest rules"
}

####################### worker ingress #######################

resource "openstack_networking_secgroup_rule_v2" "worker-kubelet-ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10250
  port_range_max    = 10250
  remote_ip_prefix  = openstack_networking_subnet_v2.ktest.cidr
  security_group_id = openstack_networking_secgroup_v2.worker.id
}


resource "openstack_networking_secgroup_rule_v2" "worker-nodeport-ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 30000
  port_range_max    = 32767
  remote_ip_prefix  = openstack_networking_subnet_v2.ktest.cidr
  security_group_id = openstack_networking_secgroup_v2.worker.id
}

resource "openstack_networking_secgroup_rule_v2" "worker-api-ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_ip_prefix  = openstack_networking_subnet_v2.ktest.cidr
  security_group_id = openstack_networking_secgroup_v2.worker.id
}


resource "openstack_networking_secgroup_rule_v2" "worker-calico-ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 179
  port_range_max    = 179
  remote_ip_prefix  = openstack_networking_subnet_v2.ktest.cidr
  security_group_id = openstack_networking_secgroup_v2.worker.id
}


####################### end of worker ingress #######################
resource "openstack_networking_secgroup_rule_v2" "worker-kubelet-egress" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10250
  port_range_max    = 10250
  remote_ip_prefix  = openstack_networking_subnet_v2.ktest.cidr
  security_group_id = openstack_networking_secgroup_v2.worker.id
}

resource "openstack_networking_secgroup_rule_v2" "worker-api-egress" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_ip_prefix  = openstack_networking_subnet_v2.ktest.cidr
  security_group_id = openstack_networking_secgroup_v2.worker.id
}

resource "openstack_networking_secgroup_rule_v2" "worker-calico-egress" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 179
  port_range_max    = 179
  remote_ip_prefix  = openstack_networking_subnet_v2.ktest.cidr
  security_group_id = openstack_networking_secgroup_v2.worker.id
}

####################### worker egress #######################

####################### connect #######################
# # add open ports for workers
# resource "openstack_networking_secgroup_v2" "connect" {
#   name        = "connect"
#   description = "ktest rules"
# }

# resource "openstack_networking_secgroup_rule_v2" "connect-allow-6443" {
#   direction         = "egress"
#   ethertype         = "IPv4"
#   protocol          = "tcp"
#   port_range_min    = 6443
#   port_range_max    = 6443
#   remote_ip_prefix  = openstack_networking_subnet_v2.ktest.cidr
#   security_group_id = openstack_networking_secgroup_v2.connect.id
# }

# ####################### end of connect #######################

####################### end of worker egress #######################

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
