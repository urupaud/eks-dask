terraform {
  backend "s3" {
    key            = "Eks/eks_state"
    encrypt        = "true"
    bucket         = "dask-tf-remote-state-storage"
    dynamodb_table = "terraform-state-lock-dynamo"
    region         = "us-east-1"
  }
}