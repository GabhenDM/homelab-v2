terraform {
  required_providers {
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

provider "kubernetes" {
    host                   = var.k8s_host
    client_key                  = var.client_key
    client_certificate = var.client_certificate
    cluster_ca_certificate = var.cluster_ca_certificate
}
provider "helm" {
  kubernetes = {
    host                   = var.k8s_host
    client_key                  = var.client_key
    client_certificate = var.client_certificate
    cluster_ca_certificate = var.cluster_ca_certificate
  }
}

