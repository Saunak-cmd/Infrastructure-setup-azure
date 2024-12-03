provider "azurerm" {
  features {}
  subscription_id = "f027d2e5-7ece-41c4-8a19-54dfa1d3491d"
}

# Step 1: Reference the existing Resource Group
data "azurerm_resource_group" "existing_rg" {
  name = "RG-saunak"  # Name of the existing Resource Group
}

# Step 2: Reference the existing Azure Container Registry (ACR)
data "azurerm_container_registry" "existing" {
  name                = "registrysaunak"  # Name of your existing ACR
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

# Step 2: Create Azure Kubernetes Service (AKS) Cluster in the existing Resource Group
resource "azurerm_kubernetes_cluster" "AKS" {
  name                = "cluster-saunak"           # Hardcoded AKS name
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  dns_prefix          = "cluster-saunak"           # Hardcoded DNS prefix

  default_node_pool {
    name       = "default"
    node_count = 2                          # Number of nodes in the cluster
    vm_size    = "Standard_DS2_v2"          # VM size for the AKS nodes
  }

  identity {
    type = "SystemAssigned"   # Managed identity
  }

  # ACR Integration: Enable AKS to pull images from the ACR
  private_cluster_enabled = false

  tags = {
    Env = "Dev"  
    owner = "saunak"     # Hardcoded Tag
  }
}

# Role Assignment to allow AKS to pull from ACR (this is done by setting up ACR as a scope for the role assignment)
  role_assignment {
    principal_id = azurerm_kubernetes_cluster.example.kube_admin_client_id
    scope        = data.azurerm_container_registry.existing.id
    role_definition_name = "AcrPull"  # The role that allows pulling images from ACR
  }
}

# Step 3: Output the Kubernetes Cluster Credentials
output "aks_kube_config" {
  value     = azurerm_kubernetes_cluster.example.kube_config.0.raw_kube_config
  sensitive = true
}

# Step 4: Output the ACR Login Server (hardcoded ACR name)
output "acr_login_server" {
  value = data.azurerm_container_registry.existing.login_server # Hardcoded ACR login server
}

# Step 6: Output the ACR Username (registrysaunak)
output "acr_username" {
  value = "registrysaunak"  # Hardcoded ACR username
}
