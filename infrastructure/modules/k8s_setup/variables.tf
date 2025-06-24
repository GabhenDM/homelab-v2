variable "argocd_namespace" {
  description = "Namespace to install Argo CD into"
  type        = string
  default     = "argocd"
}

variable "argocd_chart_version" {
  description = "Version of the Argo CD Helm chart"
  type        = string
  default     = "8.1.1"
}

variable "client_certificate" {
  description = "Client certificate for Kubernetes authentication"
  type        = string
  sensitive   = true
}

variable "client_key" {
  description = "Client key for Kubernetes authentication"
  type        = string
  sensitive   = true
}

variable "cluster_ca_certificate" {
  description = "Cluster CA certificate for Kubernetes authentication"
  type        = string
  sensitive   = true
}

variable "k8s_host" {
  description = "Kubernetes cluster endpoint URL"
  type        = string
}
