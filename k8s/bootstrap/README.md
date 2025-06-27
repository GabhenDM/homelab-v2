# ArgoCD Bootstrap

This directory contains the root "apps of apps" applications that bootstrap the entire GitOps setup.

## Structure

```
bootstrap/
├── infra-apps.yaml    # Root app that manages infrastructure applications
├── app-apps.yaml      # Root app that manages user applications
└── README.md          # This file
```

## Deployment Process

### Prerequisites

1. Kubernetes cluster is running
2. ArgoCD is installed and accessible
3. Repository access is configured in ArgoCD

### Bootstrap Steps

1. **Apply the bootstrap applications:**
   ```bash
   kubectl apply -f k8s/bootstrap/infra-apps.yaml
   kubectl apply -f k8s/bootstrap/app-apps.yaml
   ```

2. **Verify deployment:**
   ```bash
   # Check ArgoCD applications
   kubectl get applications -n argocd
   
   # Check infrastructure components
   kubectl get pods -n metallb-system
   ```

### What Gets Deployed

#### Infrastructure Applications (`infra-apps`)
- **MetalLB**: Load balancer for bare metal clusters
  - **Installation**: Deployed via Helm chart
  - **Namespace**: `metallb-system`
  - **IP Pool**: `192.168.1.240-192.168.1.250`
  - **L2 Advertisement enabled**

#### User Applications (`app-apps`)
- Directory structure ready for future applications
- Applications will be deployed in their own namespaces

## Directory Structure After Bootstrap

```
k8s/
├── bootstrap/           # Root apps of apps (this directory)
├── infra/              # Infrastructure applications
│   ├── applications/   # ArgoCD Application definitions
│   └── helm/           # Helm values for infrastructure charts
└── apps/               # User applications
    ├── applications/   # ArgoCD Application definitions
    └── manifests/      # Application manifests
```

## Adding New Applications

### Infrastructure Applications
1. Create manifests in `k8s/infra/manifests/<app-name>/`
2. Create ArgoCD Application in `k8s/infra/applications/<app-name>.yaml`
3. Commit and push - ArgoCD will automatically deploy

### User Applications
1. Create manifests in `k8s/apps/manifests/<app-name>/`
2. Create ArgoCD Application in `k8s/apps/applications/<app-name>.yaml`
3. Commit and push - ArgoCD will automatically deploy

## Troubleshooting

### Check ArgoCD Applications
```bash
kubectl get applications -n argocd
kubectl describe application <app-name> -n argocd
```

### Check Application Logs
```bash
kubectl logs -n argocd deployment/argocd-application-controller
```

### Force Sync
```bash
argocd app sync <app-name>
