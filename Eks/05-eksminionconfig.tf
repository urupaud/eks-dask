data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-1.13-v*"]
  }

  most_recent = true
  owners      = ["amazon"]
}

data "aws_region" "current" {}

locals {
  eks-minion-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks-cluster.certificate_authority.0.data}' '${var.cluster-name}'
USERDATA
}

resource "aws_launch_configuration" "eks-minion-lc" {
  associate_public_ip_address = false
  iam_instance_profile        = "${aws_iam_instance_profile.dask-eks-minion-iam-role.name}"
  image_id                    = "${data.aws_ami.eks-worker.id}"
  instance_type               = "t3.small"
  spot_price                  = "${var.dask-worker-price}"
  name_prefix                 = "eks-minion-lc"
  key_name                    = "dask-eks"
  security_groups             = ["${aws_security_group.eks-minion-sg.id}"]
  user_data_base64            = "${base64encode(local.eks-minion-userdata)}"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_iam_role.dask-eks-minion-iam-role]
}

resource "aws_autoscaling_group" "eks-minion-asg" {
  desired_capacity     = 1
  launch_configuration = "${aws_launch_configuration.eks-minion-lc.id}"
  max_size             = 2
  min_size             = 1
  name                 = "eks-minion-asg"
  spot_max_price       = "${var.dask-worker-price}"
  spot_allocation_strategy  = "lowest-price"
  vpc_zone_identifier  = ["${data.aws_subnet.eks-private-subnet-01.id}","${data.aws_subnet.eks-private-subnet-02.id}","${data.aws_subnet.eks-private-subnet-03.id}"]

  tag {
    key                 = "Name"
    value               = "eks-minion"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }
}