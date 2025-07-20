
locals {
  image_name_template = "talos-%s-%s-%s.img"
}

module "talos_image" {
  source    = "../../modules/talos-image"
  for_each  = toset([for node in var.k8s_nodes : node.host_node])
  image     = var.image
  host_node = each.value
}
module "control_plane" {
  source = "../../modules/proxmox-vm"

  for_each = { for k, v in var.k8s_nodes : k => v if v.machine_type == "controlplane" }

  name            = each.key
  host_node       = each.value.host_node
  ip              = each.value.ip
  mac_address     = each.value.mac_address
  vm_id           = each.value.vm_id
  cpu             = each.value.cpu
  memory          = each.value.ram_dedicated
  disk_size       = 20
  description     = "Kubernetes Control Plane Node ${each.key}"
  datastore_id    = "local-lvm"
  image_file_name = each.value.update ? format(local.image_name_template, coalesce(var.image.update_schematic_id, var.image.schematic_id), coalesce(var.image.update_version, var.image.version), var.image.arch) : format(local.image_name_template, var.image.schematic_id, var.image.version, var.image.arch)
  igpu            = each.value.igpu
  gateway         = "10.0.0.1" // TODO: avoid hardcoding gateway
  subnet_mask     = "24"
  dns             = ["8.8.8.8", "8.8.4.4"] // TODO: avoid hardcoding DNS


  tags       = ["kubernetes", "controlplane"]
  ssh_keys   = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEBaIwmXjnVCI651O4wwlH2B1fPYpEL3G/Q29ZxwcD9J gabhendm@anton"] // TODO: avoid hardcodding ssh_keys
  depends_on = [module.talos_image]
}

module "workers" {
  source = "../../modules/proxmox-vm"

  for_each = { for k, v in var.k8s_nodes : k => v if v.machine_type != "controlplane" }

  name            = each.key
  host_node       = each.value.host_node
  ip              = each.value.ip
  mac_address     = each.value.mac_address
  vm_id           = each.value.vm_id
  cpu             = each.value.cpu
  memory          = each.value.ram_dedicated
  disk_size       = 20
  description     = "Kubernetes Worker Node ${each.key}"
  datastore_id    = "local-lvm"
  image_file_name = each.value.update ? format(local.image_name_template, coalesce(var.image.update_schematic_id, var.image.schematic_id), coalesce(var.image.update_version, var.image.version), var.image.arch) : format(local.image_name_template, var.image.schematic_id, var.image.version, var.image.arch)
  igpu            = each.value.igpu
  gateway         = "10.0.0.1"
  subnet_mask     = "24"
  dns             = ["8.8.8.8", "8.8.4.4"]


  tags       = ["kubernetes", "controlplane"]
  ssh_keys   = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEBaIwmXjnVCI651O4wwlH2B1fPYpEL3G/Q29ZxwcD9J gabhendm@anton"]
  depends_on = [module.talos_image]

}



module "talos_machine_config" {
  source = "../../modules/talos-machine-config"

  k8s_nodes = var.k8s_nodes
  image     = var.image
  cluster   = var.talos_cluster_config

  depends_on = [
    module.control_plane,
    module.workers
  ]
}


module "cluster_config" {
  source = "../../modules/k8s_setup"

  client_certificate     = base64decode(module.talos_machine_config.kubernetes_client_certificate)
  client_key             = base64decode(module.talos_machine_config.kubernetes_client_key)
  cluster_ca_certificate = base64decode(module.talos_machine_config.cluster_ca_certificate)
  k8s_host               = module.talos_machine_config.kubernetes_host

}

output "control_plane_ips" {
  description = "IPs of the k3s control-plane nodes"
  value       = [for cp in module.control_plane : cp.vm_ip]
}

output "worker_ips" {
  description = "IPs of the k3s worker nodes"
  value       = [for w in module.workers : w.vm_ip]
}