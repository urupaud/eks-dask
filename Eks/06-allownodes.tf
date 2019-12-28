#this need helm to talk with tiller in eks cluster

provider "kubernetes" {
  host                      = aws_eks_cluster.eks-cluster.endpoint
  cluster_ca_certificate    = base64decode(aws_eks_cluster.eks-cluster.certificate_authority.0.data)
  token                     = data.aws_eks_cluster_auth.dask-eks.token
  load_config_file          = false
  version = "~> 1.5"
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 120"
  }

  triggers = {
    "before" = aws_eks_cluster.eks-cluster.id
  }
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name = "aws-auth"
    namespace = "kube-system"
  }
  data ={
    mapRoles = <<EOF
- rolearn: ${aws_iam_role.dask-eks-minion-iam-role.arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
EOF
  }
  depends_on = [aws_iam_role.dask-eks-minion-iam-role, null_resource.delay]
} 