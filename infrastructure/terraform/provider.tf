terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.78.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
    
  }
}

provider "proxmox" {
  # Configuration options
    endpoint = var.pm_endpoint
    username     = var.pm_user
    password = var.pm_password
    insecure = true
}