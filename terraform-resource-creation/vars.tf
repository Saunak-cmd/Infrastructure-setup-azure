variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}
 
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}
 
variable "location" {
  description = "Location for the resources"
  type        = string
}
 
variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}
 
variable "subnet_name" {
  description = "Name of the Subnet"
  type        = string
}
 
variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
}
 
variable "vm_size" {
  description = "Size of the Virtual Machine"
  type        = string
}
 
variable "vm_admin_username" {
  description = "Admin username for the VM"
  type        = string
}
 
variable "vm_admin_password" {
  description = "Admin password for the VM"
  type        = string
}
 
variable "vm_image_publisher" {
  description = "Publisher for the VM image"
  type        = string
}
 
variable "vm_image_offer" {
  description = "Offer for the VM image"
  type        = string
}
 
variable "vm_image_sku" {
  description = "SKU for the VM image"
  type        = string
}
 
variable "vm_image_version" {
  description = "Version for the VM image"
  type        = string
}
 
variable "additional_disk_name" {
  description = "additional disk name"
  type        = string
}
 
variable "additional_disk_size_gb" {
  description = "additional disk size"
  type        = number
}

# variable "tags" {
#     owner = "saunak"
#     project = "Final-Capstone"
#     env = "dev"
#     dep = "IT"
# }

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    owner = "saunak"
    project = "Final-Capstone"
    env = "dev"
    dep = "IT"
  }
}
