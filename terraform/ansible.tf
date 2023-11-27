resource "ansible_group" "all" {
  name     = "all"
  children = [ansible_group.workers.name, ansible_group.masters.name, ansible_group.connect.name]
  variables = {
    ansible_connection = "ssh"
    ansible_user = "ubuntu"
    ansible_ssh_pipelining = "yes"
		ansible_ssh_private_key_file =  "~/.ssh/${var.key_pair}"
    network_cidr = openstack_networking_subnet_v2.ktest.cidr
  }
}

resource "ansible_group" "connect" {
  name     = "connect"
}

resource "ansible_group" "workers" {
  name     = "workers"
}

resource "ansible_group" "masters" {
  name     = "masters"
}

resource "ansible_group" "registry" {
  name     = "masters"
}

resource "ansible_host" "connect" {
  name   = openstack_compute_instance_v2.connect.name
  groups = [ansible_group.connect.name]

  variables = {
    ansible_host = openstack_compute_floatingip_associate_v2.connect_ip.floating_ip
    private_ip = openstack_compute_instance_v2.connect.network[0].fixed_ip_v4
  }
}


resource "ansible_host" "registry" {
  name   = openstack_compute_instance_v2.registry.name
  groups = [ansible_group.registry.name]

  variables = {
    ansible_host = openstack_compute_floatingip_associate_v2.registry_ip.floating_ip
    private_ip = openstack_compute_instance_v2.registry.network[0].fixed_ip_v4
  }
}


resource "ansible_host" "masters" {
  count = var.master_count
  name   = openstack_compute_instance_v2.masters[count.index].name
  groups = [ansible_group.masters.name]

  variables = {
    ansible_host = openstack_compute_floatingip_associate_v2.masters_ips[count.index].floating_ip
    private_ip = openstack_compute_instance_v2.masters[count.index].network[0].fixed_ip_v4
  }
}

resource "ansible_host" "workers" {
  count = var.inst_count
  name   = openstack_compute_instance_v2.workers[count.index].name
  groups = [ansible_group.workers.name]

  variables = {
    ansible_host = openstack_compute_floatingip_associate_v2.workers_ips[count.index].floating_ip
    private_ip = openstack_compute_instance_v2.workers[count.index].network[0].fixed_ip_v4
  }
}

# ansible-inventory -i inventory.yml --list -y ## > test
# ansible-playbook -i inventory.yml hpcaas.yml
