locals {
  file_id_template = "local:iso/%s"
}

resource "proxmox_virtual_environment_vm" "this" {
  node_name = var.host_node

  name        = var.name
  description = var.description
  tags        = var.tags
  on_boot     = true
  vm_id       = var.vm_id

  machine       = "q35"
  scsi_hardware = "virtio-scsi-single"
  bios          = "seabios"

  agent {
    enabled = true
  }

  cpu {
    cores = var.cpu
    type  = "host"
  }

  memory {
    dedicated = var.memory
  }

  network_device {
    bridge      = "vmbr0"
    mac_address = var.mac_address
  }

  dynamic "network_device" {
    for_each = var.secondary_interface_enabled ? [1] : []
    content {
      bridge  = "vmbr0"
      vlan_id = var.secondary_vlan_id
    }
  }

  disk {
    datastore_id = var.datastore_id
    interface    = "scsi0"
    iothread     = true
    cache        = "writethrough"
    discard      = "on"
    ssd          = true
    file_format  = "raw"
    size         = var.disk_size
    file_id      = format(local.file_id_template, var.image_file_name)
  }

  boot_order = ["scsi0"]

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 6.X.
  }

  initialization {
    datastore_id = var.datastore_id

    # Optional DNS Block.  Update with a list value to use.
    dynamic "dns" {
      for_each = try(var.dns, null) != null ? { "enabled" = var.dns } : {}
      content {
        servers = var.dns
      }
    }

    ip_config {
      ipv4 {
        address = "${var.ip}/${var.subnet_mask}"
        gateway = var.gateway
      }
    }
    dynamic "ip_config" {
      for_each = var.secondary_interface_enabled != null ? [1] : []
      content {
      ipv4 {
        address = "${var.secondary_ip}/${var.secondary_subnet_mask}"
        gateway = var.secondary_gateway
      }
      }
    }
    user_account {
      keys     = var.ssh_keys
      username = var.username
    }
  }

  dynamic "hostpci" {
    for_each = var.igpu ? [1] : []
    content {
      # Passthrough iGPU
      device  = "hostpci0"
      mapping = "iGPU"
      pcie    = true
      rombar  = true
      xvga    = false
    }
  }
}
