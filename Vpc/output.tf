output "eks-vpc-id" {
  value       = aws_vpc.eks-vpc.id
  description = "The VPC ID of eks-vpc."
}

output "eks-public-subnet-01" {
  value       = aws_subnet.eks-public-subnet-01.id
  description = "The subnet ID of public subnet 01."
}

output "eks-public-subnet-02" {
  value       = aws_subnet.eks-public-subnet-02.id
  description = "The subnet ID of public subnet 02."
}

output "eks-public-subnet-03" {
  value       = aws_subnet.eks-public-subnet-03.id
  description = "The subnet ID of public subnet 03."
}

output "eks-private-subnet-01" {
  value       = aws_subnet.eks-private-subnet-01.id
  description = "The subnet ID of private subnet 01."
}

output "eks-private-subnet-02" {
  value       = aws_subnet.eks-private-subnet-02.id
  description = "The subnet ID of private subnet 02."
}

output "eks-private-subnet-03" {
  value       = aws_subnet.eks-private-subnet-03.id
  description = "The subnet ID of private subnet 03."
}