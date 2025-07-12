# Opella-DevOps-tasks
Project Overview

This repository contains Terraform code for provisioning Azure infrastructure in a modular, reusable way to support multiple environments (e.g. dev, test, prod).

Key goals of this project:

Store Terraform state securely in Azure
Authenticate deployments using a Service Principal
Implement reusable Terraform modules
Enable deployment of core network and security resources
Prepare for further expansion of infrastructure
✔️ Resources Implemented

As part of this setup, the following resources have been successfully provisioned:

Resource Group
Virtual Network (VNet)
Subnets
Network Security Groups (NSG)
NSG Rules
NSG–Subnet Associations
⏳ Resources Planned (but Not Deployed Yet)

The following resources have Terraform code already implemented in modules, but have not yet been deployed due to time constraints:

Private Endpoint
Storage Account with Blob Container and File Share
These resources can be deployed in the future simply by enabling the relevant Terraform modules and variables.

🔐 Terraform State Management

Backend Configuration
Terraform state is stored remotely in Azure Storage for secure and consistent management.
A separate resource group, storage account, and blob container were manually created via the Azure portal for holding the Terraform state file.
🔑 Authentication

A Service Principal (SP) was created in Azure AD for authenticating Terraform actions.
This SP is used by GitHub Actions for CI/CD deployments.
The Service Principal has been granted the necessary Azure roles to:

Create and manage resources in target subscriptions and resource groups
Access the remote state storage
⚙️ Deployment Automation

GitHub Actions Workflow
A GitHub Actions pipeline has been implemented to:

Authenticate to Azure using OIDC (federated identity)
Run the following Terraform steps:
terraform init
terraform validate
terraform plan
terraform apply (optionally gated with approval)
The pipeline uses Azure/login for authentication and ensures secure deployment directly from GitHub to Azure.


---------------------------

We have github actions pipeline as well for the multi environment deployments. we just need to pass the environmnet reference from the drop down and that will take care of everything.

----------------------------

Also managed approvals and repo level secrets without hardcoding in the code.