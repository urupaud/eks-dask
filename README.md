# eks-dask
Dask running on EKS cluster

Prerequistst - Please make sure to create a S3 bucket named as "dask-tf-remote-state-storage"  & dynamodb table as "terraform-state-lock-dynamo" with 

1. First move to Vpc directory and run "terraform init" then "terraform apply --auto-approve" to create the VPC. Once the VPC created you'll get the VPC ID and subnet IDs.

2. Then move to Eks directory and replace default values of VPC and Subnet variables with the values you got from step 1.

3. After you replace VPC IC / Subnet IDs you can run "terraform apply" to create the EKS Cluster.

4. To destroy the cluster simply run "terraform destroy" inside Eks directory again.