provider "azurerm" {
  features {}
}

# Step 1: Create Resource Group
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

# Step 2: Create Azure Kubernetes Service (AKS) Cluster
resource "azurerm_kubernetes_cluster" "example" {
  name                = var.aks_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "myakscluster"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Dev"
  }
}

# Step 3: Output the Kubernetes Cluster Credentials
output "aks_kube_config" {
  value     = azurerm_kubernetes_cluster.example.kube_config.0.raw_kube_config
  sensitive = true
}

# Step 4: Output the ACR Login Server
output "acr_login_server" {
  value = "${var.acr_name}.azurecr.io"  # Use the ACR name from the variable
}
