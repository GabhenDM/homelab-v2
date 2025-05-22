# terraform.tfvars

pm_endpoint         = "https://192.168.1.2:8006//api2/json"


template_node       = "anton-01"
template_vm_id      = 9000
cloudinit_datastore = "local-lvm"

vm_count            = 2
vm_name_prefix      = "k8s"
ssh_public_key_path = "/home/gabhen/.ssh/id_rsa.pub"

ip_base             = "192.168.1"
ip_start_offset     = 20
gateway             = "192.168.1.1"

cores               = 2
memory              = 4096

node_vms = {
  "anton-01" = {
    vm_count        = 2
    vm_name_prefix  = "anton01-master"
    ip_base         = "192.168.1"
    ip_start_offset = 20
    cores           = 2
    memory          = 4096
    network_bridge  = "vmbr0"
  }
  "anton-02" = {
    vm_count        = 1
    vm_name_prefix  = "anton02-master"
    ip_base         = "192.168.1"
    ip_start_offset = 30
    cores           = 1
    memory          = 2048
    network_bridge  = "vmbr0"
  }
}