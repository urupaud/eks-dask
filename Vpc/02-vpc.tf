# Define our VPC
resource "aws_vpc" "eks-vpc" {
  cidr_block           = "${var.eks-vpc-cidr}"
  enable_dns_hostnames = true
  #enable_classiclink    = true

  tags = {
    Name = "eks-vpc"
  }
}

#Define public subnets
resource "aws_subnet" "eks-public-subnet-01" {
  vpc_id            = "${aws_vpc.eks-vpc.id}"
  cidr_block        = "${var.eks-public-subnet-cidr-01}"
  availability_zone = "us-east-1a"

  tags = {
    Name = "eks-pub-sub-01"
  }
}

resource "aws_subnet" "eks-public-subnet-02" {
  vpc_id            = "${aws_vpc.eks-vpc.id}"
  cidr_block        = "${var.eks-public-subnet-cidr-02}"
  availability_zone = "us-east-1b"

  tags = {
    Name = "eks-pub-sub-02"
  }
}

resource "aws_subnet" "eks-public-subnet-03" {
  vpc_id            = "${aws_vpc.eks-vpc.id}"
  cidr_block        = "${var.eks-public-subnet-cidr-03}"
  availability_zone = "us-east-1c"

  tags = {
    Name = "eks-pub-sub-03"
  }
}

#Define private subnets
resource "aws_subnet" "eks-private-subnet-01" {
  vpc_id            = "${aws_vpc.eks-vpc.id}"
  cidr_block        = "${var.eks-private-subnet-cidr-01}"
  availability_zone = "us-east-1a"

  tags = {
    Name = "eks-prv-sub-01"
  }
}

resource "aws_subnet" "eks-private-subnet-02" {
  vpc_id            = "${aws_vpc.eks-vpc.id}"
  cidr_block        = "${var.eks-private-subnet-cidr-02}"
  availability_zone = "us-east-1b"

  tags = {
    Name = "eks-prv-sub-02"
  }
}

resource "aws_subnet" "eks-private-subnet-03" {
  vpc_id            = "${aws_vpc.eks-vpc.id}"
  cidr_block        = "${var.eks-private-subnet-cidr-03}"
  availability_zone = "us-east-1c"

  tags = {
    Name = "eks-prv-sub-03"
  }
}


# Define internet gateway
resource "aws_internet_gateway" "eks-igw" {
  vpc_id = "${aws_vpc.eks-vpc.id}"

  tags = {
    Name = "eks-igw"
  }
}

#Define nat gateway
resource "aws_eip" "eks-nat-gw-eip" {
  vpc                       = true
  tags = {
    Name = "eks-nat-gw-eip"
  }
}

resource "aws_nat_gateway" "eks-nat-gw" {
  allocation_id = "${aws_eip.eks-nat-gw-eip.id}"
  subnet_id     = "${aws_subnet.eks-public-subnet-01.id}"
  tags = {
    Name = "eks-nat-gw"
  }

  depends_on = ["aws_internet_gateway.eks-igw","aws_eip.eks-nat-gw-eip"]
}

#Define the public route table
resource "aws_route_table" "eks-pub-rtb" {
  vpc_id = "${aws_vpc.eks-vpc.id}"

  tags = {
    Name = "eks-pub-rtb"
  }
}

#Define the private route table
resource "aws_route_table" "eks-prv-rtb" {
  vpc_id = "${aws_vpc.eks-vpc.id}"
  tags = {
    Name = "eks-prv-rtb"
  }
}

# Assign the public subnets to public route table
resource "aws_route_table_association" "eks-pub-rtb-assoc-01" {
  subnet_id      = "${aws_subnet.eks-public-subnet-01.id}"
  route_table_id = "${aws_route_table.eks-pub-rtb.id}"
}

resource "aws_route_table_association" "eks-pub-rtb-assoc-02" {
  subnet_id      = "${aws_subnet.eks-public-subnet-02.id}"
  route_table_id = "${aws_route_table.eks-pub-rtb.id}"
}

resource "aws_route_table_association" "eks-pub-rtb-assoc-03" {
  subnet_id      = "${aws_subnet.eks-public-subnet-03.id}"
  route_table_id = "${aws_route_table.eks-pub-rtb.id}"
}

# Assign the private subnets to private route table
resource "aws_route_table_association" "eks-prv-rtb-assoc-01" {
  subnet_id      = "${aws_subnet.eks-private-subnet-01.id}"
  route_table_id = "${aws_route_table.eks-prv-rtb.id}"
}

resource "aws_route_table_association" "eks-prv-rtb-assoc-02" {
  subnet_id      = "${aws_subnet.eks-private-subnet-02.id}"
  route_table_id = "${aws_route_table.eks-prv-rtb.id}"
}

resource "aws_route_table_association" "eks-prv-rtb-assoc-03" {
  subnet_id      = "${aws_subnet.eks-private-subnet-03.id}"
  route_table_id = "${aws_route_table.eks-prv-rtb.id}"
}

#Route to internet gateway from public route table
resource "aws_route" "eks-igw-route" {
  route_table_id            = "${aws_route_table.eks-pub-rtb.id}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = "${aws_internet_gateway.eks-igw.id}"
  depends_on                = ["aws_route_table.eks-pub-rtb","aws_internet_gateway.eks-igw"]
}

resource "aws_route" "eks-nat-gw-route" {
  route_table_id            = "${aws_route_table.eks-prv-rtb.id}"
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id                = "${aws_nat_gateway.eks-nat-gw.id}"
  depends_on                = ["aws_route_table.eks-prv-rtb","aws_nat_gateway.eks-nat-gw"]
}