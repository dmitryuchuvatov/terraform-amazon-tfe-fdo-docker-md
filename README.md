# Terraform Enterprise Flexible Deployment Options - Mounted Disk mode on Docker (AWS)

This repository creates a new installation of TFE FDO in Mounted Disk mode on Docker (AWS)

# Diagram

![tfe_fdo_on_docker_in_mounted_disk_mode](https://github.com/dmitryuchuvatov/terraform-amazon-tfe-fdo-docker-md/assets/119931089/52ac5af2-9542-4567-8aff-fb10f3c028cc)

# Prerequisites
+ Have Terraform installed as per the [official documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

+ AWS account

+ TFE FDO license

# How To

## Clone repository

```
git clone https://github.com/dmitryuchuvatov/terraform-amazon-tfe-fdo-docker-md.git
```

## Change folder

```
cd terraform-amazon-tfe-fdo-docker-md
```

## Rename the file called `terraform.tfvars-sample` to `terraform.tfvars` and replace the values with your own.
The current content is below:

```
region              = "eu-west-3"                           # AWS region to deploy in
environment_name    = "dmitry-fdo-md"                       # Name of the environment, used in naming of resources
vpc_cidr            = "10.200.0.0/16"                       # The IP range for the VPC
route53_zone        = "tf-support.hashicorpdemo.com"        # The domain of your hosted zone in Route 53
route53_subdomain   = "dmitry-fdo-md"                       # The subomain of the URL
cert_email          = "dmitry.uchuvatov@hashicorp.com"      # The email address used to register the certificate                                                                                                     tfe_release         = "v202402-4"                           # TFE release version (https://developer.hashicorp.com/terraform/enterprise/releases)
tfe_password        = "Password1#"                          # TFE encryption password                         
tfe_license         = "02MV4U...."                          # Value from the license file                                                                                                                      
```

## Set AWS credentials

```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=
```

## Terraform initialize

```
terraform init
```

## Terraform plan

```
terraform plan
```

## Terraform apply

```
terraform apply
```

When prompted, type **yes** and hit **Enter** to start provisioning AWS infrastructure and installing TFE FDO on it

You should see the similar result:

```
Apply complete! Resources: 22 added, 0 changed, 0 destroyed.

Outputs:

ssh_login    = "ssh -i tfesshkey.pem ubuntu@dmitry-fdo-md.tf-support.hashicorpdemo.com"
tfe_hostname = "https://dmitry-fdo-md.tf-support.hashicorpdemo.com"
```

## Next steps

[Provision your first administrative user](https://developer.hashicorp.com/terraform/enterprise/flexible-deployments/install/initial-admin-user) and start using Terraform Enterprise.

