data "proxmox_virtual_environment_vm" "ubuntu_template" {
  node_name = var.template_node
  vm_id     = var.template_vm_id
}


locals {
  vm_defs = flatten([
    for node, cfg in var.node_vms : [
      for idx in range(cfg.vm_count) : {
        name    = "${cfg.vm_name_prefix}-${idx + 1}"
        node    = node
        ip      = format("%s.%d", cfg.ip_base, cfg.ip_start_offset + idx)
        cores   = cfg.cores
        memory  = cfg.memory
        bridge  = cfg.network_bridge
      }
    ]
  ])
}


resource "proxmox_virtual_environment_vm" "k8s_node" {
  for_each  = { for vm in local.vm_defs : "${vm.node}-${vm.name}" => vm }
  name      = each.value.name
  node_name = each.value.node

  # Clone the existing cloud‐init template
  clone {
    vm_id = data.proxmox_virtual_environment_vm.ubuntu_template.vm_id
    node_name = var.template_node
    full  = true
  }
 
  cpu    { cores = each.value.cores }
  memory { dedicated = each.value.memory }

  network_device {
    bridge = each.value.bridge
    model  = "virtio"
  }
  agent {
    enabled = true
  }
  disk {
    size = 80
    interface = "scsi0"
  }

  initialization {
    datastore_id = var.cloudinit_datastore
    interface    = "ide2"

    user_account {
      username = "gabhendm"
      # read your public key from the path in var.ssh_public_key_path
      keys     = [file(var.ssh_public_key_path)]
    }

    ip_config {
      ipv4 {
        address = "${each.value.ip}/24"
        gateway = var.gateway
      }
    }
  }
}

output "vm_ipv4_addresses" {
  description = "Map of each VM key (node-name/name) to its actual IPv4 address"
  value = {
    for key, vm in proxmox_virtual_environment_vm.k8s_node :
    key => vm.ipv4_addresses[1][0]
  }
}
