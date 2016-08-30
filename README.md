# Demo AWS environment stack

## Features

- Immutable web server layer
- Automated tests for AWS resources provisioning and web server build process
- CI/CD pipeline integrated with Github

## Tools used to create stack

- HashiCorp Atlas for infrastructure-focused CI/CD workflow, provisioning testing, cloud credentials management, AMI artifact tracking
- Terraform for AWS infrastructure provisioning
- Packer for AMI builds to deliver immutable images
- Chef for configuration management
- Inspec for server configuration automated testing

## Resources

This demo stack creates the following AWS resources:
- VPC with Internet Gateway and NAT Gateway
- 2 public and 2 private subnets in 2 different AZs
- Routing tables for public (via IGW) and private (via NAT GW) subnets
- Routing table associations to subnets
- Security Groups for ELB (HTTP from all) and Web servers (HTTP from ELB)
- AutoScaling group for web servers using 2 different AZs
- ELB using 2 different AZs

## Usage instructions

### CI environment setup

- Sign up for an Atlas account at https://atlas.hashicorp.com/account/new
- Enable trial of Terraform Enterprise in Atlas
- Switch to Terraform using Product selection menu on top left
- Initialize a Terraform/Github integration and grant access for Atlas
- Create a new Terraform Environment in Atlas
- Either clone this repo (if you'd like to test CI aspects) or use this target
- Set "GitHub repository" to "username/repo_name" of this repo or your clone.
- Set "Path to directory of Terraform files" to "/terraform"
- Select "Variable" from left menu, set the following variables: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY (check "sensitive on both"), TF_VAR_atlas_org_name - set to your Atlas handle you selected when creating your Atlas account
- Switch to Packer using Product selection menu on top left
- Initialize a Packer/Github integration and grant access for Atlas
- Create a new Packer Build Configuration
- Set "GitHub repository" to "username/repo_name" of this repo or your clone.
- Set "Packer directory" to "packer"
- Set "Packer template" to "awslinux.json"


### AMI Build
