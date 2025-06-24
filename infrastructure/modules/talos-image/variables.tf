variable "image" {
  description = "Talos image configuration"
  type = object({
    version             = string
    update_version      = optional(string)
    schematic_id        = string
    update_schematic_id = optional(string)
    platform            = optional(string, "nocloud")
    arch                = optional(string, "amd64")
  })
}

variable "host_node" {
  description = "Proxmox host node name"
  type        = string
}