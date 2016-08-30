# aws-env-demo

## Features

- Immutable web server layer
- Automated tests for AWS resources provisioning and web server build process
- CI/CD pipeline integrated with Github

## Tools used to create stack

- HashiCorp Atlas for infrastructure-focused CI/CD workflow, provisioning testing, cloud credentials management
- Terraform for AWS infrastructure provisioning
- Packer and Chef for AMI builds to deliver immutable images
- Inspec for server configuration automated testing

## Resources

This demo stack creates the following AWS resources:
- VPC with Internet Gateway and NAT Gateway
- 2 public and 2 private subnets in 2 different AZs
- Routing tables for public (via IGW) and private (via NAT GW) subnets
- Routing table associations to subnets
- Security Groups
