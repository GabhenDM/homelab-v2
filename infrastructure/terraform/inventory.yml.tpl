---
k3s_cluster:
  children:
    server:
      hosts:
        %{for ip in ip_addrs ~}
        ${ip}:
        %{ endfor ~} 


  # Required Vars
  vars:
    ansible_port: 22
    ansible_user: gabhendm
    k3s_version: v1.30.2+k3s1
    token: "${token}"
    api_endpoint: "{{ hostvars[groups['server'][0]]['ansible_host'] | default(groups['server'][0]) }}"

    # Optional vars
    extra_server_args: "--disable=traefik --disable=servicelb"
    # extra_agent_args: ""
    # cluster_context: k3s-ansible
    # api_port: 6443
    # k3s_server_location: /var/lib/rancher/k3s
    # systemd_dir: /etc/systemd/system
    # extra_service_envs: [ 'ENV_VAR1=VALUE1', 'ENV_VAR2=VALUE2' ]
    # user_kubectl: true, by default kubectl is symlinked and configured for use by ansible_user. Set to false to only kubectl via root user.

    # Manifests or Airgap should be either full paths or relative to the playbook directory.
