provider "aws" {
  region = "${var.eks-region}"
}

provider "helm" {
  version        = "~> 0.9"
  install_tiller = true

  service_account = "${kubernetes_service_account.tiller.metadata.0.name}"
  namespace = "${kubernetes_service_account.tiller.metadata.0.namespace}"
}