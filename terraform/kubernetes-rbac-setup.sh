#!/bin/bash
# Script to setup Kubernetes RBAC for developer access

# Create ClusterRole if it doesn't exist
kubectl apply -f - <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: developer-readonly-role
rules:
- apiGroups: [""]
  resources: ["pods", "services", "endpoints", "namespaces", "events", "configmaps", "pods/log"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets", "statefulsets", "daemonsets"]
  verbs: ["get", "list", "watch"]
YAML

# Create ClusterRoleBinding
kubectl apply -f - <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: developer-readonly-binding
subjects:
- kind: Group
  name: developer-readonly-group
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: developer-readonly-role
  apiGroup: rbac.authorization.k8s.io
YAML

echo "RBAC setup complete!"
