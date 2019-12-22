
resource "kubernetes_service_account" "tiller" {
  metadata {
    name = "tiller"
    namespace = "kube-system"
  }

  automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller"
  }

  role_ref {
    kind = "ClusterRole"
    name = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind = "ServiceAccount"
    name = "tiller"
    namespace = "kube-system"
  }

}

data "helm_repository" "helm-dask" {
  name = "helm-dask"
  url  = "https://helm.dask.org/"
}

resource "helm_release" "helm-dask-release" {
  name       = "dask-release"
  repository = data.helm_repository.helm-dask.metadata[0].name
  chart      = "dask"
}