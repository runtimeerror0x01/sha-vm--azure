# Vnet from the Firewall subscription

# data "azurerm_virtual_network" "remote_vnet" {
#   provider            = azurerm.firewall
#   name                = var.fw_vnet_name
#   resource_group_name = var.fw_resource_group_name
# }

# # Private DNS Zone resource group in the connectivity subscription

# data "azurerm_resource_group" "connectivity-sub-rg" {
#   provider = azurerm.connectivity
#   name     = "rg-chs-conn-shared-weu-privatedns"
# }

# # Vnet from the Connectivity subscription

# data "azurerm_virtual_network" "connectivity-vnet" {
#   provider            = azurerm.connectivity
#   name                = "vnet-chs-conn-shared-neu-001"
#   resource_group_name = "rg-chs-conn-shared-neu-vwan"
# }

# # Key Vault DNS Zone in the Connectivity Subscription

# data "azurerm_private_dns_zone" "conn-kv-dns" {
#   provider            = azurerm.connectivity
#   name                = "privatelink.vaultcore.azure.net"
#   resource_group_name = data.azurerm_resource_group.connectivity-sub-rg.name
# }

data "azurerm_resource_group" "agent_rg" {
  name     = var.resource_group_name
}

data "azurerm_virtual_network" "spoke_vnet" {
  name                = var.virtual_network_name
  resource_group_name = var.virtual_network_rg
}

data "azurerm_subnet" "spoke_subnet" {
  name                 = var.subnet_name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
}

data "cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    content_type = "config/cloud-init"
    # content      = "packages: ['httpie']"
  }
}

# Current client config for object and tenant ID

data "azurerm_client_config" "current" {}
