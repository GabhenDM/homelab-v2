variable "host_node" {
  description = "Proxmox host node name"
  type        = string
}

variable "datastore_id" {
  description = "Datastore ID for VM storage"
  type        = string
  default     = "local-lvm"
}

variable "description" {
  description = "VM description"
  type        = string
  default     = ""
}

variable "tags" {
  description = "VM tags"
  type        = list(string)
  default     = []
}

variable "ip" {
  description = "VM IP address"
  type        = string
}

variable "mac_address" {
  description = "VM MAC address"
  type        = string
}

variable "vm_id" {
  description = "VM ID"
  type        = number
}

variable "cpu" {
  description = "Number of CPU cores"
  type        = number
}

variable "memory" {
  description = "Dedicated RAM in MB"
  type        = number
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 20
}

variable "image_file_name" {
  description = "Disk Image to be used for VM"
  type        = string
}

variable "igpu" {
  description = "Enable integrated GPU passthrough"
  type        = bool
  default     = false
}

variable "gateway" {
  description = "Network Gateway address"
  type        = string
}
variable "name" {
  description = "VM name"
  type        = string
}
variable "ssh_keys" {
  description = "SSH public keys for the VM"
  type        = list(string)
  default     = []
}
variable "username" {
  description = "Username for the user account"
  type        = string
  default     = "gabhendm"
}

variable "dns" {
  description = "DNS servers for the VM"
  type        = list(string)
  default     = []
}

variable "subnet_mask" {
  description = "Subnet mask for the VM's IP address"
  type        = string
  default     = "24"
}