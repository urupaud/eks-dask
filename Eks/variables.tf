variable "eks-region" {
  description = "eks AWS Region"
  default     = "us-east-1"
}

variable "eks-vpc-id" {
  description = "CIDR for the eks VPC"
  default     = "vpc-09e8c6cd692d26f0f"
}

variable "eks-public-subnet-01" {
  description = "public-subnet-01 of the eks VPC"
  default     = "subnet-00a7a1d0391bb6f34"
}

variable "eks-public-subnet-02" {
  description = "public-subnet-02 of the eks VPC"
  default     = "subnet-0e8a8681b361c1148"
}

variable "eks-public-subnet-03" {
  description = "public-subnet-03 of the eks VPC"
  default     = "subnet-0813bbd31d692fbc9"
}

variable "eks-private-subnet-01" {
  description = "private-subnet-01 of the eks VPC"
  default     = "subnet-0fc3a71fc48ed9912"
}

variable "eks-private-subnet-02" {
  description = "private-subnet-02 of the eks VPC"
  default     = "subnet-03c575f93946e2c26"
}

variable "eks-private-subnet-03" {
  description = "private-subnet-03 of the eks VPC"
  default     = "subnet-0dccc57d0a0e7ca71"
}

variable "dask-worker-price" {
  description = "spot instace price"
  default     = "0.0062"
}

variable "cluster-name" {
  default = "dask-eks-cluster"
  type    = "string"
}