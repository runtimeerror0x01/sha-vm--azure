/* Uncomment this section if you would like to include a bastion resource with this example.

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.4"
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = data.azurerm_resource_group.agent_rg.name
  virtual_network_name = data.azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = [""]
}

resource "azurerm_public_ip" "bastionpip" {
  name                = module.naming.public_ip.name_unique
  location            = data.azurerm_resource_group.agent_rg.location
  resource_group_name = data.azurerm_resource_group.agent_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = module.naming.bastion_host.name_unique
  location            = data.azurerm_resource_group.agent_rg.location
  resource_group_name = data.azurerm_resource_group.agent_rg.name

  ip_configuration {
    name                 = "${module.naming.bastion_host.name_unique}-ipconf"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastionpip.id
  }
}
*/

resource "azurerm_user_assigned_identity" "identity" {
  location            = data.azurerm_resource_group.agent_rg.location
  name                = var.managed_identity_name
  resource_group_name = data.azurerm_resource_group.agent_rg.name
  tags                = local.tags
}

module "avm_res_keyvault_vault" {
  source                      = "Azure/avm-res-keyvault-vault/azurerm"
  version                     = "=0.6.2"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  name                        = var.keyvault_name
  resource_group_name         = data.azurerm_resource_group.agent_rg.name
  location                    = data.azurerm_resource_group.agent_rg.location
  enabled_for_disk_encryption = true
  network_acls = {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  role_assignments = {
    deployment_user_secrets = { #give the deployment user access to secrets
      role_definition_id_or_name = "Key Vault Secrets Officer"
      principal_id               = data.azurerm_client_config.current.object_id
    }
    deployment_user_keys = { #give the deployment user access to keys
      role_definition_id_or_name = "Key Vault Crypto Officer"
      principal_id               = data.azurerm_client_config.current.object_id
    }
    user_managed_identity_keys = { #give the user assigned managed identity for the disk encryption set access to keys
      role_definition_id_or_name = "Key Vault Crypto Officer"
      principal_id               = azurerm_user_assigned_identity.identity.principal_id
      principal_type             = "ServicePrincipal"
    }
    #   additional_user = {
    #   role_definition_id_or_name = "Key Vault Secrets Officer"
    #   principal_id               = "your-additional-user-object-id" # Replace with the actual Object ID of the additional user
    # }
  }

  wait_for_rbac_before_key_operations = {
    create = "60s"
  }

  wait_for_rbac_before_secret_operations = {
    create = "60s"
  }

  tags = local.tags

  keys = {
    des_key = {
      name     = "des-disk-key"
      key_type = "RSA"
      key_size = 2048

      key_opts = [
        "decrypt",
        "encrypt",
        "sign",
        "unwrapKey",
        "verify",
        "wrapKey",
      ]
    }
  }
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "admin_ssh_key" {
  key_vault_id = module.avm_res_keyvault_vault.resource_id
  name         = "${var.vm_name}-ssh-key"
  value        = tls_private_key.this.private_key_pem

  depends_on = [
    module.avm_res_keyvault_vault
  ]
}

resource "random_password" "admin_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_key_vault_secret" "admin_password" {
  name         = "${var.vm_name}-password"
  value        = random_password.admin_password.result
  key_vault_id = module.avm_res_keyvault_vault.resource_id

  depends_on = [
    module.avm_res_keyvault_vault
  ]
}


# resource "azurerm_disk_encryption_set" "this" {
#   key_vault_key_id    = module.avm_res_keyvault_vault.keys_resource_ids.des_key.id
#   location            = data.azurerm_resource_group.agent_rg.location
#   name                = module.naming.disk_encryption_set.name_unique
#   resource_group_name = data.azurerm_resource_group.agent_rg.name
#   tags                = local.tags

#   identity {
#     type         = "UserAssigned"
#     identity_ids = [azurerm_user_assigned_identity.identity.id]
#   }
# }

module "linux_vm" {
  source = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.15.0"

  name                               = "${var.vm_name_prefix}-vm"
  location                           = data.azurerm_resource_group.agent_rg.location
  resource_group_name                = data.azurerm_resource_group.agent_rg.name
  admin_username                     = var.admin_username
  admin_password                     =  random_password.admin_password.result
  disable_password_authentication    = false
  generate_admin_password_or_ssh_key = false
  os_type                            = "Linux"
  source_image_resource_id           = var.source_image_id
  sku_size                           = var.vmSku          
  custom_data                        = data.cloudinit_config.config.rendered
  zone                               = null

  admin_ssh_keys = [
    {
      public_key = tls_private_key.this.public_key_openssh
      username   = var.admin_username #the username must match the admin_username currently.
    }
  ]

  data_disk_managed_disks = {
    disk1 = {
      name                   = "${var.vm_name_prefix}-lun"
      storage_account_type   = "Premium_LRS"
      lun                    = 0
      caching                = "ReadWrite"
      disk_size_gb           = 128
      # disk_encryption_set_id = azurerm_disk_encryption_set.this.id
      resource_group_name    = data.azurerm_resource_group.agent_rg.name
      role_assignments = {
        role_assignment_2 = {
          principal_id               = data.azurerm_client_config.current.client_id
          role_definition_id_or_name = "Contributor"
          description                = "Assign the Contributor role to the deployment user on this managed disk resource scope."
          principal_type             = "ServicePrincipal"
        }
      }
    }
  }

  managed_identities = {
    system_assigned            = false
    user_assigned_resource_ids = [azurerm_user_assigned_identity.identity.id]
  }
  network_interfaces = {
    network_interface_1 = {
      name                           = "${var.vm_name_prefix}-nic"
      accelerated_networking_enabled = true
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "${var.vm_name_prefix}-nic1-ipconfig1"
          private_ip_address_allocation = "Dynamic"
          private_ip_subnet_resource_id = data.azurerm_subnet.spoke_subnet.id
        }
      }
      resource_group_name = data.azurerm_resource_group.agent_rg.name
    }
  }

  os_disk = {
    caching                = "ReadWrite"
    storage_account_type   = "Premium_LRS"
    # disk_encryption_set_id = azurerm_disk_encryption_set.this.id
  }

  role_assignments = {
    role_assignment_2 = {
      principal_id               = data.azurerm_client_config.current.client_id
      role_definition_id_or_name = "Virtual Machine Contributor"
      description                = "Assign the Virtual Machine Contributor role to the deployment user on this virtual machine resource scope."
      principal_type             = "ServicePrincipal"
    }
   role_assignment_3 = {
      principal_id               = azurerm_user_assigned_identity.identity.principal_id
      role_definition_id_or_name = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/4633458b-17de-408a-b874-0445c86b69e6"  # Replace with the correct role definition ID
      description                = "Assign the User Identity, Secret User role."
      principal_type             = "ServicePrincipal"
   }
  }

  # source_image_reference = {

  #   publisher = local.source_image_reference.publisher
  #   offer     = local.source_image_reference.offer
  #   sku       = local.source_image_reference.sku
  #   version   = local.source_image_reference.version
  # }

  tags = local.tags

  depends_on = [
    module.avm_res_keyvault_vault
  ]
}