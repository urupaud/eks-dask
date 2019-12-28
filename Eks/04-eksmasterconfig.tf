data "aws_subnet" "eks-public-subnet-01" {
  id = var.eks-public-subnet-01
}

data "aws_subnet" "eks-public-subnet-02" {
  id = var.eks-public-subnet-02
}

data "aws_subnet" "eks-public-subnet-03" {
  id = var.eks-public-subnet-03
}

data "aws_subnet" "eks-private-subnet-01" {
  id = var.eks-private-subnet-01
}

data "aws_subnet" "eks-private-subnet-02" {
  id = var.eks-private-subnet-02
}

data "aws_subnet" "eks-private-subnet-03" {
  id = var.eks-private-subnet-03
}

resource "aws_eks_cluster" "eks-cluster" {
  name     = var.cluster-name
  role_arn = aws_iam_role.dask-eks-master-iam-role.arn

  vpc_config {
    security_group_ids = [aws_security_group.eks-master-sg.id]
    subnet_ids         = [data.aws_subnet.eks-public-subnet-01.id,data.aws_subnet.eks-public-subnet-02.id,data.aws_subnet.eks-public-subnet-03.id,data.aws_subnet.eks-private-subnet-01.id,data.aws_subnet.eks-private-subnet-02.id,data.aws_subnet.eks-private-subnet-03.id]
  } 
  
  depends_on = [aws_iam_role.dask-eks-master-iam-role, aws_security_group.eks-master-sg]

}