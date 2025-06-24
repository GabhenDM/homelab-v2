module "k8s" {
  source = "./apps/k8s-cluster"

  talos_cluster_config = var.talos_cluster_config
  k8s_nodes            = var.k8s_nodes
  image                = var.talos_image
}