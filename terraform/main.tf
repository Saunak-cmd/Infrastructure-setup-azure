provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
terraform {
  backend "azurerm" {
   resource_group_name   = "RG-Swati"
   storage_account_name  = "swati21224"
    container_name        = "container1"
   key                   = "terraform2.tfstate"
  }
  }
# Reference the existing resource group
data "azurerm_resource_group" "existing_rg" {
  name = var.existing_resource_group_name
}
resource "azurerm_container_registry" "container" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = data.azurerm_resource_group.existing_rg.location
  sku                  = var.acr_sku
  admin_enabled       = true
 
  tags = var.tags
}
 
resource "azurerm_kubernetes_cluster" "example_kc" {
  name                = var.aks_name
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  dns_prefix          = var.aks_dns_prefix
 
  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
  }
 
  identity {
    type = "SystemAssigned"
  }
 
  tags = var.tags
}