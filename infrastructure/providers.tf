terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.78.1"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0-alpha.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "3.0.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.37.1"
    }
  }
}

provider "talos" {
  # Configuration options
}


provider "proxmox" {
  endpoint = var.proxmox.endpoint
  insecure = var.proxmox.insecure

  api_token = var.proxmox_api_token
  ssh {
    username    = "root"
    agent       = false
    private_key = file("~/.ssh/id_ed25519")
  }
}