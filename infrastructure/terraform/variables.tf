// variables.tf

variable "pm_endpoint" {
  description = "Proxmox API endpoint (e.g. https://pve.example.com:8006/api2/json)"
  type        = string
}

variable "pm_insecure" {
  description = "Allow insecure TLS connections to Proxmox API"
  type        = bool
  default     = true
}

variable "pm_user" {
  description = "Proxmox user (e.g. terraform@pam)"
  type        = string
}

variable "pm_password" {
  description = "Password for the Proxmox user"
  type        = string
  sensitive   = true
}

variable "template_node" {
  description = "Proxmox node where your Ubuntu cloud-init template lives"
  type        = string
}

variable "template_vm_id" {
  description = "VMID of the Ubuntu cloud-init template"
  type        = number
}

variable "cloudinit_datastore" {
  description = "Datastore to host the cloud-init drive"
  type        = string
  default     = "local-lvm"
}

variable "vm_count" {
  description = "How many identical VMs to create"
  type        = number
  default     = 1
}

variable "vm_name_prefix" {
  description = "Prefix for each VM’s name"
  type        = string
  default     = "ubuntu-cloud"
}

variable "ssh_public_key_path" {
  description = "Path to your SSH public key for cloud-init"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ip_base" {
  description = "Base network for VM IPs (without last octet)"
  type        = string
  default     = "192.168.1"
}

variable "ip_start_offset" {
  description = "Offset to add to starting last-octet (e.g. with vm 1 → .101)"
  type        = number
  default     = 100
}

variable "gateway" {
  description = "Default gateway for the VMs"
  type        = string
  default     = "192.168.1.1"
}

variable "dns_servers" {
  description = "DNS servers to inject via cloud-init"
  type        = list(string)
  default     = ["8.8.8.8", "1.1.1.1"]
}

variable "cores" {
  description = "vCPU cores per VM"
  type        = number
  default     = 2
}

variable "memory" {
  description = "RAM in MB per VM"
  type        = number
  default     = 2048
}

variable "network_bridge" {
  description = "Proxmox bridge for the VM NIC"
  type        = string
  default     = "vmbr0"
}

variable "ubuntu_cloud_image" {
    description = "Image to be used in Template"
    type = string
    default = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

variable "node_vms" {
  description = "Mapping of Proxmox nodes to the VMs we should create on each"
  type = map(object({
    vm_count        = number        # how many VMs on that node
    vm_name_prefix  = string        # prefix for each VM’s name
    ip_base         = string        # network base (no last octet)
    ip_start_offset = number        # starting offset for last octet
    cores           = number        # vCPU per VM
    memory          = number        # RAM in MB per VM
    network_bridge  = string        # bridge for the NIC
  }))
}