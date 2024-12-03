variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "myResourceGroup"
}

variable "location" {
  description = "The Azure region where the resources will be created"
  type        = string
  default     = "East US"
}

variable "aks_name" {
  description = "The name of the AKS cluster"
  type        = string
  default     = "myakscluster"
}

variable "acr_name" {
  description = "The name of the manually created ACR"
  type        = string
  default     = "myacrregistry"  # Replace this with your ACR name
}
