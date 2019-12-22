variable "eks-region" {
  description = "eks AWS Region"
  default     = "us-east-1"
}

variable "eks-vpc-cidr" {
  description = "CIDR for the eks VPC"
  default     = "10.100.0.0/20"
}

variable "eks-public-subnet-cidr-01" {
  description = "CIDR for the eks public subnet 01"
  default     = "10.100.0.0/24"
}

variable "eks-public-subnet-cidr-02" {
  description = "CIDR for the eks public subnet 02"
  default     = "10.100.2.0/24"
}

variable "eks-public-subnet-cidr-03" {
  description = "CIDR for the eks public subnet 03"
  default     = "10.100.4.0/24"
}

variable "eks-private-subnet-cidr-01" {
  description = "CIDR for the eks private subnet 01"
  default     = "10.100.1.0/24"
}

variable "eks-private-subnet-cidr-02" {
  description = "CIDR for the eks private subnet 02"
  default     = "10.100.3.0/24"
}

variable "eks-private-subnet-cidr-03" {
  description = "CIDR for the eks private subnet 03"
  default     = "10.100.5.0/24"
}