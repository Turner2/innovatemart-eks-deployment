# terraform/main.tf

# ... (AWS provider and module calls here) ...

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  
  # CRITICAL FIX: The provider MUST depend on the EKS cluster being created.
  # Otherwise, it attempts to read non-existent cluster outputs during 'terraform init/plan'.
  # This dependency ensures the provider configuration is only valid AFTER EKS is built.
  # The module.eks outputs are defined in terraform/eks/outputs.tf.
  depends_on = [
    module.eks,
    # Add any resources the Kubernetes provider interacts with first, e.g.,
    # aws_eks_cluster.main (if you used separate resource blocks)
  ]

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      module.eks.cluster_name
    ]
  }
}
