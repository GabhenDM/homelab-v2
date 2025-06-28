locals {
  first_control_plane_node_ip = [for k, v in var.k8s_nodes : v.ip if v.machine_type == "controlplane"][0]
  kubernetes_endpoint         = coalesce(var.cluster.vip, local.first_control_plane_node_ip)
  extra_manifests             = concat(var.cluster.extra_manifests, [])
}

resource "talos_machine_secrets" "this" {
  // Changing talos_version causes trouble as new certs are created
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster.name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = [for k, v in var.k8s_nodes : v.ip]
  endpoints            = [for k, v in var.k8s_nodes : v.ip if v.machine_type == "controlplane"]
}

# resource "terraform_data" "cilium_bootstrap_inline_manifests" {
#   input = [
#     {
#       name     = "cilium-bootstrap"
#       contents = file("${path.root}/${var.cluster.cilium.bootstrap_manifest_path}")
#     },
#     {
#       name = "cilium-values"
#       contents = yamlencode({
#         apiVersion = "v1"
#         kind       = "ConfigMap"
#         metadata = {
#           name      = "cilium-values"
#           namespace = "kube-system"
#         }
#         data = {
#           "values.yaml" = file("${path.root}/${var.cluster.cilium.values_file_path}")
#         }
#       })
#     }
#   ]
# }

data "talos_machine_configuration" "this" {
  for_each         = var.k8s_nodes
  cluster_name     = var.cluster.name
  cluster_endpoint = "https://${local.kubernetes_endpoint}:6443"
  talos_version    = each.value.update == true ? var.image.update_version : var.image.version
  machine_type     = each.value.machine_type
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  config_patches = [
    templatefile("${path.module}/templates/common.yaml.tftpl", {
      node_name          = each.value.host_node
      cluster_name       = var.cluster.proxmox_cluster
      kubernetes_version = var.cluster.kubernetes_version
      hostname           = each.key
      kubelet            = var.cluster.kubelet
    }), each.value.machine_type == "controlplane" ?
    templatefile("${path.module}/templates/control-plane.yaml.tftpl", {
      ip               = each.value.ip
      mac_address      = lower(each.value.mac_address)
      gateway          = var.cluster.gateway
      subnet_mask      = var.cluster.subnet_mask
      vip              = var.cluster.vip
      extra_manifests  = jsonencode(local.extra_manifests)
      api_server       = var.cluster.api_server
      inline_manifests = ""
    }) :
    templatefile("${path.module}/templates/worker.yaml.tftpl", {
      ip          = each.value.ip
      mac_address = lower(each.value.mac_address)
      gateway     = var.cluster.gateway
      subnet_mask = var.cluster.subnet_mask
    })
  ]
}

resource "terraform_data" "talos_version" {
  for_each = var.k8s_nodes
  input    = each.value.update == true ? var.image.update_version : var.image.version
}


resource "talos_machine_configuration_apply" "this" {
  for_each                    = var.k8s_nodes
  node                        = each.value.ip
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.this[each.key].machine_configuration
  lifecycle {
    replace_triggered_by = [terraform_data.talos_version[each.key]]
  }
}

resource "talos_machine_bootstrap" "this" {
  depends_on           = [talos_machine_configuration_apply.this]
  node                 = local.first_control_plane_node_ip
  client_configuration = talos_machine_secrets.this.client_configuration
}

data "talos_cluster_health" "this" {
  depends_on = [
    talos_machine_configuration_apply.this,
    talos_machine_bootstrap.this
  ]
  skip_kubernetes_checks = false
  client_configuration   = data.talos_client_configuration.this.client_configuration
  control_plane_nodes    = [for k, v in var.k8s_nodes : v.ip if v.machine_type == "controlplane"]
  worker_nodes           = [for k, v in var.k8s_nodes : v.ip if v.machine_type == "worker"]
  endpoints              = data.talos_client_configuration.this.endpoints
  timeouts = {
    read = "10m"
  }
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on = [
    talos_machine_bootstrap.this,
    data.talos_cluster_health.this
  ]
  # The kubeconfig endpoint will be populated from the talos_machine_configuration cluster_endpoint
  node                 = local.first_control_plane_node_ip
  client_configuration = talos_machine_secrets.this.client_configuration
  timeouts = {
    read = "1m"
  }
}