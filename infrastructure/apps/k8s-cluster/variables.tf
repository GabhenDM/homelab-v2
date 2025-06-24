variable "talos_cluster_config" {
  description = "Talos cluster configuration"
  type = object({
    name                         = string
    vip                          = optional(string)
    gateway                      = string
    subnet_mask                  = optional(string, "24")
    talos_machine_config_version = optional(string)
    proxmox_cluster              = string
    kubernetes_version           = string
    # gateway_api_version          = string
    extra_manifests = optional(list(string), [])
    kubelet         = optional(string)
    api_server      = optional(string)
    cilium = object({
      bootstrap_manifest_path = string
      values_file_path        = string
    })
  })
}

variable "k8s_nodes" {
  type = map(
    object({
      host_node     = string
      machine_type  = string
      ip            = string
      dns           = optional(list(string))
      mac_address   = string
      vm_id         = number
      cpu           = number
      ram_dedicated = number
      update        = optional(bool, false)
      igpu          = optional(bool, false)
    })
  )
  validation {
    // @formatter:off
    condition     = length([for n in var.k8s_nodes : n if contains(["controlplane", "worker"], n.machine_type)]) == length(var.k8s_nodes)
    error_message = "Node machine_type must be either 'controlplane' or 'worker'."
    // @formatter:on
  }
}

variable "image" {
  description = "Talos image configuration"
  type = object({
    version             = string
    update_version      = optional(string)
    schematic_id        = string
    update_schematic_id = optional(string)
    arch                = optional(string, "amd64")
  })
}