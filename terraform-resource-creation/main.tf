provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
 
terraform {
  backend "azurerm" {
    resource_group_name   = "RG-saunak"
    storage_account_name  = "saunak021224"
    container_name        = "container-saunak"
    key                   = "terraform.tfstate"
  }
}
 
# Resource Group
data "azurerm_resource_group" "existing_rg" {
  name = var.resource_group_name
}
 
# Virtual Network
data "azurerm_virtual_network" "existing_vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}
 
# Subnet
data "azurerm_subnet" "existing_subnet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
}
 
# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
 
  security_rule {
    name                       = "AllowSSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "ALLOW8000"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
 
# Public IP Address
resource "azurerm_public_ip" "vm_public_ip" {
  name                = "public-ip-saunak"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
 
# Network Interface for Linux VM
resource "azurerm_network_interface" "nic_linux" {
  name                = "nic-saunak"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
 
  ip_configuration {
    name                          = "ipcongif-saunak"
    subnet_id                     = data.azurerm_subnet.existing_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
}
 
# Associate NSG with NIC
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic_linux.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
 
# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                            = "vm1-saunak"
  resource_group_name             = data.azurerm_resource_group.existing_rg.name
  location                        = data.azurerm_resource_group.existing_rg.location
  size                            = var.vm_size
  admin_username                  = var.vm_admin_username
  #admin_password                  = var.vm_admin_password
  disable_password_authentication = true
  admin_ssh_key {
    username = var.vm_admin_username
    public_key = file("~/.ssh/id_rsa.pub")
  }
 
  network_interface_ids = [azurerm_network_interface.nic_linux.id]
 
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
 
  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }
 
  plan {
    name      = var.vm_image_sku
    publisher = var.vm_image_publisher
    product   = var.vm_image_offer
  }
 
  custom_data = base64encode(<<EOT
#!/bin/bash
 
# Update the package repository
sudo dnf -y update
 
#script to install ansible
sudo dnf install epel-release -y
sudo dnf install ansible -y

# # Create a directory for the agent and download it
# mkdir -p /home/adminuser/myagent && cd /home/adminuser/myagent
# wget https://vstsagentpackage.azureedge.net/agent/3.248.0/vsts-agent-linux-x64-3.248.0.tar.gz
# tar zxvf vsts-agent-linux-x64-2.220.0.tar.gz

# # Configure the Azure DevOps agent
# ./config.sh --unattended --url https://dev.azure.com/saunakdevops/ \
#   --auth pat --token wCZpSIkwwv1Tk1v2awAZYLEnMvrSepm9bLK5WmqOUkyMC4PbMsjkJQQJ99ALACAAAAAAAAAAAAASAZDOAYdp \
#   --pool YourAgentPoolName --agent agentcap \
#   --acceptTeeEula --work _work

# # Install and start the agent as a service
# ./run.sh
 
ansible
EOT
  )
  tags = var.tags
}
 
# Managed Disk
resource "azurerm_managed_disk" "additional_disk" {
  name                 = var.additional_disk_name
  location             = data.azurerm_resource_group.existing_rg.location
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.additional_disk_size_gb
}
 
# Data Disk Attachment
resource "azurerm_virtual_machine_data_disk_attachment" "disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.additional_disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.linux_vm.id
  lun                = 0
  caching            = "ReadWrite"
}
 
 
# Output Public IP Address
output "vm_public_ip" {
  value = azurerm_public_ip.vm_public_ip.ip_address
}
