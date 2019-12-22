variable "eks-region" {
  description = "eks AWS Region"
  default     = "us-east-1"
}

variable "eks-vpc-id" {
  description = "CIDR for the eks VPC"
  default     = "vpc-0fb01e048ec1855f1"
}

variable "eks-public-subnet-01" {
  description = "public-subnet-01 of the eks VPC"
  default     = "subnet-0ef512a72a5485e83"
}

variable "eks-public-subnet-02" {
  description = "public-subnet-02 of the eks VPC"
  default     = "subnet-039037a9fe7e49730"
}

variable "eks-public-subnet-03" {
  description = "public-subnet-03 of the eks VPC"
  default     = "subnet-0df3e069356898e7c"
}

variable "eks-private-subnet-01" {
  description = "private-subnet-01 of the eks VPC"
  default     = "subnet-0eec7a927708a7848"
}

variable "eks-private-subnet-02" {
  description = "private-subnet-02 of the eks VPC"
  default     = "subnet-0ce59d0ad15c3deab"
}

variable "eks-private-subnet-03" {
  description = "private-subnet-03 of the eks VPC"
  default     = "subnet-0d75dbf072aaa2a92"
}

variable "dask-worker-price" {
  description = "spot instace price"
  default     = "0.0062"
}

variable "cluster-name" {
  default = "dask-eks-cluster"
  type    = "string"
}