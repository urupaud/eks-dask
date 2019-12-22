terraform {
  backend "s3" {
    encrypt        = "true"
    bucket         = "dask-tf-remote-state-storage"
    dynamodb_table = "terraform-state-lock-dynamo"
    region         = "us-east-1"
    key            = "Vpc/vpc_state"
  }
}
