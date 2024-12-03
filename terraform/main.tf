provider "azurerm" {
  features {}
  subscription_id = "f027d2e5-7ece-41c4-8a19-54dfa1d3491d"  # Replace with your Azure Subscription ID
}

terraform {
  backend "azurerm" {
    resource_group_name   = "RG-saunak"
    storage_account_name  = "saunak021224"
    container_name        = "container-saunak"
    key                   = "terraform2.tfstate"
  }
}

# Reference the existing resource group
data "azurerm_resource_group" "existing_rg" {
  name = "existing-resource-group"  # Replace with your actual existing resource group name
}

resource "azurerm_container_registry" "container" {
  name                = "registrysaunak"  # Replace with your ACR name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = data.azurerm_resource_group.existing_rg.location
  sku                  = "Basic"  # Replace with the ACR SKU you want (Basic, Standard, Premium)
  admin_enabled       = true

  tags = {
    environment = "dev"  # Optional: Replace with your tags
  }
}

resource "azurerm_kubernetes_cluster" "example_kc" {
  name                = "cluster-saunak"  # Replace with your AKS cluster name
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  dns_prefix          = "myaks"  # Replace with your DNS prefix for the AKS cluster

  default_node_pool {
    name       = "default"
    node_count = 3  # Replace with your desired node count
    vm_size    = "Standard_DS2_v2"  # Replace with your desired VM size
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "dev"
    owner = "saunak  "  # Optional: Replace with your tags
  }
}
