# Demo AWS environment delivery pipeline

## Features

- Immutable web server layer using ASG, with no-downtime update workflow
- Automated tests for AWS resources provisioning and web server AMI build process
- CI/CD pipeline integrated with Github. Once configured, deployment of infrastructure and web application is driven by Github commits, with optional release approval workflows via Atlas

## Tools used to create stack

- HashiCorp Atlas for infrastructure-focused CI/CD workflows, provisioning testing, cloud credentials management, AMI artifact tracking
- Terraform for AWS infrastructure provisioning
- Packer for AMI builds to deliver immutable images
- Chef for configuration management
- Inspec for server configuration automated testing

## Resources

This demo stack creates the following AWS resources:
- VPC with Internet Gateway and NAT Gateway
- 2 public and 2 private subnets in 2 different AZs
- Routing tables for public (via IGW) and private (via NAT GW) subnets
- Routing table associations for subnets
- Security Groups for ELB (HTTP from all) and Web servers (HTTP from ELB)
- AutoScaling group for web servers using 2 different AZs, with rolling update triggers on new AMI artifacts
- ELB using 2 different AZs

## Usage instructions

### CI environment setup

#### Atlas account setup
- Sign up for an Atlas account at https://atlas.hashicorp.com/account/new

#### Terraform configuration in Atlas
- Enable trial of Terraform Enterprise in Atlas.
- Switch to Terraform using Product selection menu on top left.
- Initialize a Terraform/Github integration and grant access for Atlas.
- Create a new Terraform Environment in Atlas.
- Either clone this repo (if you'd like to test CI aspects) or use this repo as source for configuration.
- Set "GitHub repository" to "username/repo_name" of this repo or your clone.
- Set "Path to directory of Terraform files" to "/terraform".
- Check "Plan on artifact uploads".
- Select "Variables" from left menu, set the following variables: "AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY" (check "sensitive on both"), "TF_VAR_atlas_org_name" - set to your Atlas handle you selected when creating your Atlas account.

#### Packer configuration in Atlas
- Switch to Packer using Product selection menu on top left.
- Initialize a Packer/Github integration and grant access for Atlas.
- Create a new Packer Build Configuration
- Set "GitHub repository" to "username/repo_name" of this repo or your clone.
- Set "Packer directory" to "packer".
- Set "Packer template" to "awslinux.json".
- Select "Variables" from left menu, set the following variables: "AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY" (check "sensitive on both"), "ATLAS_ORG_NAME" - set to the Atlas handle you selected when creating your Atlas account, BUILD_VPC_ID - set to the ID of an existing VPC, BUILD_SG_ID - set to the ID of an existing VPC security group, BUILD_SUBNET_ID - set to the ID of an existing VPC subnet. BUILD_* variables are used to identify AWS runtime environment for Packer to provision scratch instances when building AMIs.

### Release workflows

#### Building AMIs

- Switch to Packer using Product selection menu on top left.
- Select Builds > Queue build. This will initiate an AMI build based on the configuration under /packer directory of this repo. This build process uses a simple Chef cookbook to install Nginx and configure test page, and then runs Inspec tests to validate configuration. At the end of a successful build, it produces an AMI in your AWS account, and registers this AMI as an artifact in Atlas.

#### Provisioning infrastructure

- Switch to Terraform using Product selection menu on top left
- Terraform will queue a Plan operation (under "Runs" menu) on AMI Artifact upload event. Review the output of a Plan, and if everything passes, confirm and apply. This will kick off provisioning of a load-balanced stack against your AWS account.
- Once completed, browse to the ELB URL and review test page text.

#### Making changes to web app

- You can test web app release workflow by changing the page text - modify the respective attribute in "demo_nginx_config" cookbook (located under packer/cookbooks) and commit to Github.
- Queue a Packer build as above, then review and apply a Terraform run. This will perform a rolling update - replacement operation on ASG and its instances, while maintaining uptime for the web application.

## Why it is build this way

The goal is to demo automated deployment pipeline capabilities for both infrastructure and application revisions. While this stack is simplifying some of the aspects (Chef cookbook is basic, more Inspec tests can be created), it provides a blueprint for production-ready setup.

## Postmortem

Everything went relatively smoothly (normal iterative process to fix typos, work through bugs, etc.), considering that Atlas is a fairly new tool. There were some issues immediately after Atlas account provisioning, as well as minor UI/UX issues with the Atlas web interface.

Packer, Chef, Inspec provide a solid foundation for building production-ready immutable images.

Increasingly pleased with Terraform, in particular productivity gains when compared to CloudFormation, and integration with Atlas for state storage and locking.

Atlas is a purpose-build tool focused on immutable infrastructure delivery workflows, and provides capabilities out of the box that are typically stitched together using Jenkins plugins or custom scripts.

Tool selection and overall approach was driven by the desire to produce a foundation for a production-ready setup.
