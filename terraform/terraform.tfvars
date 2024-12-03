# subscription_id          = "67e4852b-fef3-4cf9-980d-f1a51712d9a1"
# tenant_id                = "1bd6dde0-eaf2-4aba-81f1-c731c24f26a5"
# resource_group_name      = "RG-Swati"
# location                 = "Central India"
# vnet_name                = "vnet-Swati"
 
 
 
subscription_id          = "67e4852b-fef3-4cf9-980d-f1a51712d9a1"
location                 = "Central India"
existing_resource_group_name = "RG-Swati"
acr_name                     = "swati31224"  # Ensure this name is globally unique
acr_sku                      = "Basic"
aks_name                     = "myakscluster-swati"
aks_dns_prefix               = "myakscluster-swati"
node_count                   = 3
vm_size                      = "Standard_DS2_v2"