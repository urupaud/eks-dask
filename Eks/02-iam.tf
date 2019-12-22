resource "aws_iam_instance_profile" "dask-eks-minion-iam-role" {
  name = "dask-eks-minion-iam-role"
  role = aws_iam_role.dask-eks-minion-iam-role.name

  depends_on = [aws_iam_role.dask-eks-minion-iam-role]
}

resource "aws_iam_role" "dask-eks-minion-iam-role" {
  name = "dask-eks-minion-iam-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "attach-eksworkernode-policy" {
  role       = "${aws_iam_role.dask-eks-minion-iam-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "attach-containerregistry-policy" {
  role       = "${aws_iam_role.dask-eks-minion-iam-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "attach-ekscni-policy" {
  role       = "${aws_iam_role.dask-eks-minion-iam-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_instance_profile" "dask-eks-master-iam-role" {
  name = "dask-eks-master-iam-role"
  role = aws_iam_role.dask-eks-master-iam-role.name

  depends_on = [aws_iam_role.dask-eks-master-iam-role]
}

resource "aws_iam_role" "dask-eks-master-iam-role" {
  name = "dask-eks-master-iam-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "eks.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "attach-ekscluster-policy" {
  role       = "${aws_iam_role.dask-eks-master-iam-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "attach-eksservice-policy" {
  role       = "${aws_iam_role.dask-eks-master-iam-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}