# Applications

This directory contains ArgoCD Application definitions for user applications.

Each application should be defined as a separate YAML file that points to the corresponding manifest directory in `../manifests/`.

## Example Structure

```
applications/
├── my-app.yaml          # ArgoCD Application definition
└── another-app.yaml     # Another application definition

manifests/
├── my-app/              # Kubernetes manifests for my-app
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
└── another-app/         # Kubernetes manifests for another-app
    └── ...
