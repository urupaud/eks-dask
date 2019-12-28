data "aws_eks_cluster_auth" "dask-eks" {
  name = aws_eks_cluster.eks-cluster.name
}

provider "helm" {
  version        = "~> 0.10.4"
  install_tiller = true

  service_account = kubernetes_cluster_role_binding.tiller.metadata.0.name
  namespace = kubernetes_service_account.tiller.metadata.0.namespace

  kubernetes {
      host     = aws_eks_cluster.eks-cluster.endpoint
      cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster.certificate_authority.0.data)
      token = data.aws_eks_cluster_auth.dask-eks.token
      load_config_file = false
  }
}

resource "kubernetes_service_account" "tiller" {
  metadata {
    name = "tiller"
    namespace = "kube-system"
  }

  automount_service_account_token = true

  depends_on = [kubernetes_config_map.aws_auth]
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = kubernetes_service_account.tiller.metadata.0.name
  }

  role_ref {
    kind = "ClusterRole"
    name = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind = "ServiceAccount"
    name = "default"
    namespace = "kube-system"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.tiller.metadata.0.name
    namespace = kubernetes_service_account.tiller.metadata.0.namespace
  }

  depends_on = [kubernetes_service_account.tiller]
}

data "helm_repository" "helm-dask" {
  name = "helm-dask"
  url  = "https://helm.dask.org/"
}

resource "helm_release" "helm-dask-release" {
  name       = "dask-release"
  repository = data.helm_repository.helm-dask.metadata[0].name
  chart      = "dask"

  depends_on = [kubernetes_cluster_role_binding.tiller]
}