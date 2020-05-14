output "instance ip" {
  value = ["${google_compute_instance.kvm-host.*.network_interface.0.access_config.0.nat_ip}"]
}
