resource "random_string" "k8s_token" {
  length           = 64            # total characters
  special          = false         
  upper            = true          # include A–Z
  lower            = true          # include a–z
  numeric           = true          # include 0–9
}

locals {
  ansible_inventory = templatefile("${path.module}/inventory.yml.tpl", {
    ip_addrs =  {for key, vm in proxmox_virtual_environment_vm.k8s_node :
      key => vm.ipv4_addresses[1][0]
    }
    token    = random_string.k8s_token.result
  })
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.yml"
  content  = local.ansible_inventory
}
