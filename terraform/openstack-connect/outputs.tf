output "connect_public_ip" {
  description = "Public IP address of the compute instance"
  value       = openstack_compute_floatingip_associate_v2.connect_ip.floating_ip
}
