# eks-dask
Dask running on EKS cluster with SPOT instances.

Prerequisites - Please make sure to create a S3 bucket named as "dask-tf-remote-state-storage" & dynamodb table as "terraform-state-lock-dynamo" with LockID as partition key. 

Before executin please go through variables.tf of both Eks and Vpc directories, there you'll be able to see the variables that we should pass to create the VPC and EKS cluster. 

eg - to set a SPOT instance max price change the value of Eks/variables.tf -> dask-worker-price.

1. First move to Vpc directory and followings,

$ docker run -i -v ${absolute_path_to_Vpc_dir}:/Vpc -w /Vpc --env AWS_ACCESS_KEY_ID="XXXX" --env AWS_SECRET_ACCESS_KEY="YYYY" -t hashicorp/terraform:light init

$ docker run -i -v ${absolute_path_to_Vpc_dir}:/Vpc -w /Vpc --env AWS_ACCESS_KEY_ID="XXXX" --env AWS_SECRET_ACCESS_KEY="YYYY" -t hashicorp/terraform:light apply

Once it's created VPC you'll get Vpc id and Subnet ids as output.

2. Then move to Eks directory and replace default values of VPC and Subnet variables with the values you got as output from step 1.

3. After you replaced VPC id / Subnet ids you can run the followings to create EKS cluster,

$ docker run -i -t -v ${absolute_path_to_Eks_dir}:/Eks --net=host -w /Eks --env AWS_ACCESS_KEY_ID="XXXX" --env AWS_SECRET_ACCESS_KEY="YYYY" -t hashicorp/terraform:light init

$ docker run -i -t -v ${absolute_path_to_Eks_dir}:/Eks --net=host -w /Eks --env AWS_ACCESS_KEY_ID="XXXX" --env AWS_SECRET_ACCESS_KEY="YYYY" -t hashicorp/terraform:light apply

Upon successfull creation dask helm charts will be creating two classic loadbalancers to access dask jupyter and dask scheduler.

4. To destroy the cluster simply run followings inside Eks directory,

Make sure to destroy helm release first using the following command, this is due to a bug with terraform helm provider (https://github.com/terraform-providers/terraform-provider-helm/issues/315 / https://github.com/hashicorp/terraform/issues/21008)

$ docker run -i -t -v ${absolute_path_to_Eks_dir}:/Eks --net=host -w /Eks --env AWS_ACCESS_KEY_ID="XXXX" --env AWS_SECRET_ACCESS_KEY="YYYY" -t hashicorp/terraform:light destroy -target helm_release.helm-dask-release

After successfull deletion of helm release , then run destroy as below.

$ docker run -i -t -v ${absolute_path_to_Eks_dir}:/Eks --net=host -w /Eks --env AWS_ACCESS_KEY_ID="XXXX" --env AWS_SECRET_ACCESS_KEY="YYYY" -t hashicorp/terraform:light destroy