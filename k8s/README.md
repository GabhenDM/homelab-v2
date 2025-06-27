# Kubernetes GitOps with ArgoCD

This directory contains the complete GitOps setup for managing Kubernetes applications using ArgoCD with the "apps of apps" pattern.

## Directory Structure

```
k8s/
├── bootstrap/           # Root apps of apps - Bootstrap ArgoCD applications
│   ├── infra-apps.yaml     # Manages infrastructure applications
│   ├── app-apps.yaml       # Manages user applications
│   └── README.md           # Bootstrap documentation
├── infra/              # Infrastructure applications
│   ├── applications/       # ArgoCD Application definitions
│   │   └── metallb.yaml       # MetalLB load balancer
│   └── helm/               # Helm values for infrastructure charts
│       └── metallb/
│           └── values.yaml
└── apps/               # User applications
    ├── applications/       # ArgoCD Application definitions
    │   └── README.md          # Documentation
    └── manifests/          # Application manifests
        └── README.md          # Documentation
```

## Quick Start

### 1. Prerequisites
- Kubernetes cluster running
- ArgoCD installed via Helm (done during cluster bootstrap)
- Repository access configured in ArgoCD

### 2. Bootstrap the GitOps Setup
```bash
# Apply the root apps of apps
kubectl apply -f k8s/bootstrap/infra-apps.yaml
kubectl apply -f k8s/bootstrap/app-apps.yaml
```

### 3. Verify Deployment
```bash
# Check ArgoCD applications
kubectl get applications -n argocd

# Check MetalLB deployment
kubectl get pods -n metallb-system
kubectl get ipaddresspools -n metallb-system
kubectl get l2advertisements -n metallb-system
```

## Architecture

This setup implements the ArgoCD "apps of apps" pattern:

1. **Bootstrap Layer**: Root applications that manage other applications
2. **Infrastructure Layer**: Core cluster services (MetalLB, ingress, monitoring, etc.)
3. **Application Layer**: User applications and workloads

### Benefits
- **Declarative**: Everything is defined in Git
- **Automated**: Changes are automatically deployed
- **Scalable**: Easy to add new applications
- **Organized**: Clear separation between infrastructure and applications
- **Self-healing**: ArgoCD ensures desired state

## Adding New Applications

### Infrastructure Applications
1. Create manifests in `infra/manifests/<app-name>/`
2. Create ArgoCD Application in `infra/applications/<app-name>.yaml`
3. Commit and push - ArgoCD will automatically deploy

### User Applications
1. Create manifests in `apps/manifests/<app-name>/`
2. Create ArgoCD Application in `apps/applications/<app-name>.yaml`
3. Commit and push - ArgoCD will automatically deploy

## Current Infrastructure

### MetalLB Load Balancer
- **Installation**: Deployed via Helm chart
- **Namespace**: `metallb-system`
- **IP Pool**: `192.168.1.240-192.168.1.250`
- **Mode**: L2 Advertisement
- **Purpose**: Provides LoadBalancer services for bare metal clusters

## Monitoring and Troubleshooting

### Check Application Status
```bash
# List all ArgoCD applications
kubectl get applications -n argocd

# Get detailed application info
kubectl describe application <app-name> -n argocd

# Check ArgoCD controller logs
kubectl logs -n argocd deployment/argocd-application-controller
```

### Force Application Sync
```bash
# Using ArgoCD CLI
argocd app sync <app-name>

# Using kubectl
kubectl patch application <app-name> -n argocd --type merge -p '{"operation":{"initiatedBy":{"username":"admin"},"sync":{"revision":"HEAD"}}}'
```

## Security Considerations

- All applications use automated sync with prune and self-heal enabled
- Proper RBAC is configured for ArgoCD service accounts
- Applications are deployed in separate namespaces for isolation
- Finalizers ensure proper cleanup when applications are deleted

## Next Steps

1. **Add Ingress Controller**: For external access to services
2. **Add Cert-Manager**: For automatic TLS certificate management
3. **Add Monitoring Stack**: Prometheus, Grafana, AlertManager
4. **Add Backup Solution**: Velero for cluster backups
5. **Add Security Scanning**: Falco, OPA Gatekeeper
