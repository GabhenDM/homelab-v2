# Application Manifests

This directory contains the actual Kubernetes manifests for user applications.

Each application should have its own subdirectory containing all the necessary Kubernetes resources.

## Structure

```
manifests/
├── app-name/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   └── ingress.yaml
└── another-app/
    └── ...
```

## Guidelines

- Each application should be in its own namespace
- Use consistent naming conventions
- Include all necessary resources (deployments, services, configmaps, etc.)
- Consider using kustomization.yaml for complex applications
