data "aws_vpc" "eks-vpc" {
  id = var.eks-vpc-id
}

resource "aws_security_group" "eks-master-sg" {
  name        = "eks-master-sg"
  description = "Allow communication between master and workers"
  vpc_id      = data.aws_vpc.eks-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-master-sg"
  }
}

resource "aws_security_group" "eks-minion-sg" {
  name        = "eks-minion-sg"
  description = "Security group for all minions in the cluster"
  vpc_id      = data.aws_vpc.eks-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-minion-sg"
  }
}
	
resource "aws_security_group_rule" "eks-master-sg-ingress-workstation-https" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow workstation to communicate with the cluster API Server."
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.eks-master-sg.id
  to_port           = 443
  type              = "ingress"
}
 
resource "aws_security_group_rule" "eks-minion-sg-ingress-workstation-https" {
  cidr_blocks       = ["80.235.88.105/32"]
  description       = "Allow workstation to communicate with the Kubernetes nodes directly."
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.eks-minion-sg.id
  to_port           = 22
  type              = "ingress"
}
	
# Setup worker node security group
 
resource "aws_security_group_rule" "eks-minion-sg-ingress-self" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks-minion-sg.id
  source_security_group_id = aws_security_group.eks-minion-sg.id
  to_port                  = 65535
  type                     = "ingress"
}
 
resource "aws_security_group_rule" "eks-minion-sg-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-minion-sg.id
  source_security_group_id = aws_security_group.eks-master-sg.id
  to_port                  = 65535
  type                     = "ingress"
}
 
# allow worker nodes to access eks master
resource "aws_security_group_rule" "tf-eks-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-minion-sg.id
  source_security_group_id = aws_security_group.eks-master-sg.id
  to_port                  = 443
  type                     = "ingress"
}
 
resource "aws_security_group_rule" "eks-minion-sg-ingress-master" {
  description              = "Allow cluster control to receive communication from the worker Kubelets"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-master-sg.id
  source_security_group_id = aws_security_group.eks-minion-sg.id
  to_port                  = 443
  type                     = "ingress"
}