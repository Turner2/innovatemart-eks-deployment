#!/bin/bash

echo "🚀 Deploying Retail Store Application to EKS..."

# Apply namespace first
echo "Creating namespace..."
kubectl apply -f manifests/namespace.yaml

# Wait a moment for namespace to be created
sleep 2

# Apply all other manifests
echo "Deploying application components..."
kubectl apply -f manifests/

# Wait for deployments to be ready
echo "⏳ Waiting for deployments to be ready (this may take 5-10 minutes)..."
kubectl wait --for=condition=available --timeout=600s deployment --all -n retail-store

# Get service endpoints
echo ""
echo "✅ Application deployed successfully!"
echo ""
echo "📊 Service Information:"
kubectl get svc -n retail-store

echo ""
echo "🎯 Pod Status:"
kubectl get pods -n retail-store

echo ""
echo "🌐 To access the UI, run:"
echo "   kubectl port-forward -n retail-store svc/ui 8080:80"
echo ""
echo "Then open your browser to: http://localhost:8080"
