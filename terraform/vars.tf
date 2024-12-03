variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}
variable "existing_resource_group_name" {
  description = "The name of the existing resource group"
  type        = string
}
 
variable "location" {
  description = "Azure location where resources will be created"
  type        = string
}
 
variable "acr_name" {
  description = "The name of the Azure Container Registry"
  type        = string
 
}
 
variable "acr_sku" {
  description = "The SKU of the Azure Container Registry"
  type        = string
}
 
variable "aks_name" {
  description = "The name of the Azure Kubernetes Service cluster"
  type        = string
}
 
variable "aks_dns_prefix" {
  description = "The DNS prefix used for the AKS cluster"
  type        = string
}
 
variable "node_count" {
  description = "Number of nodes in the default AKS node pool"
  type        = number
}
 
variable "vm_size" {
  description = "VM size for the AKS nodes"
  type        = string
}
 
variable "tags" {
   description = "Common tags for all resources"
  type        = map(string)
  default = {
    owner = "Swati"
    project = "Final-Capstone"
    Env = "dev"
    Dep = "IT"
  }
}