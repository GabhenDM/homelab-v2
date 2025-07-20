k8s_nodes = {
  "moria-00" = {
    host_node     = "anton-01"
    machine_type  = "controlplane"
    ip            = "10.0.0.100"
    secondary_ip  = "10.0.10.10"
    mac_address   = "BC:24:11:2E:C8:00"
    vm_id         = 800
    cpu           = 2
    ram_dedicated = 4096
    igpu          = false
    update        = false
  }
  "moria-01" = {
    host_node     = "anton-02"
    machine_type  = "controlplane"
    ip            = "10.0.0.101"
    secondary_ip  = "10.0.10.11"
    mac_address   = "BC:24:11:2E:C8:01"
    vm_id         = 900
    cpu           = 2
    ram_dedicated = 4096
    igpu          = false
    update        = false
  }
  "moria-02" = {
    host_node     = "anton-02"
    machine_type  = "controlplane"
    ip            = "10.0.0.103"
    secondary_ip  = "10.0.10.13"
    mac_address   = "BC:24:11:2E:C8:02"
    vm_id         = 901
    cpu           = 2
    ram_dedicated = 4096
    igpu          = false
    update        = false
  }
}

talos_cluster_config = {
  name    = "talos"
  gateway = "10.0.0.1"
  # talos_machine_config_version = "v1.9.2"
  proxmox_cluster    = "anton"
  kubernetes_version = "v1.33.3" # renovate: github-releases=kubernetes/kubernetes
  cilium = {
    bootstrap_manifest_path = "modules/talos-machine-config/manifests/cilium-install.yaml"
    values_file_path        = "../k8s/infra/network/values.yaml"
  }
  #   gateway_api_version = "v1.3.0" # renovate: github-releases=kubernetes-sigs/gateway-api
  extra_manifests = []
  kubelet         = ""
  api_server      = ""
}

talos_image = {
  version        = "v1.10.4"
  update_version = "v1.10.4"
  schematic_id   = "62d0931f10c2d9734427318cc15c4fd6a0317866434e53f1bcbecab204bfc688"
  # update_schematic_id = "talos-v1.9.3"
}