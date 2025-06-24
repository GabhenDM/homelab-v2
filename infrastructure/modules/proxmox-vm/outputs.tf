output "vm_ip" {
  description = "IP of the VM"
  value       = proxmox_virtual_environment_vm.this.ipv4_addresses != null ? proxmox_virtual_environment_vm.this.ipv4_addresses[0] : null
}
 