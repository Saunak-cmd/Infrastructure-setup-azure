Virtual Machine Creation:​

Provision a Windows 11 virtual machine (VM) with a public IP and username, password.​

Access the VM using SSH or Remote Desktop (RDP).​

Azure Environment Setup:​

Configure  a Storage Account, Container, Resource Group (RG), Virtual Network (VNet), and two Subnets in Azure portal manually.​

Terraform Configuration:​

Install and set up Terraform to create a new Linux VM.​

Linux VM Deployment:​

Deploy a Rocky Linux VM, attach a 3GB volume, configure /etc/fstab for persistent mounting, and register the VM as an Azure DevOps agent.​

Pipeline Configuration:​

Use an Ansible playbook to install JDK17, Maven, Kubernetes CLI (kubectl), Docker, and Azure CLI on the VM.​

Infrastructure Provisioning:​

Install Terraform in the new VM to deploy an Azure Container Registry (ACR) and an Azure Kubernetes Service (AKS) cluster using Terraform.​

Branch Management:​

Create and manage separate branches in Azure Repos:​

      Dev for development work.​

      Feature for individual tasks.​

      Main for stable production-ready code.​