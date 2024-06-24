module "linux_vm" {
  source = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.15.0"

  name                               = "${var.vm_name_prefix}-vm"
  location                           = data.azurerm_resource_group.agent_rg.location
  resource_group_name                = data.azurerm_resource_group.agent_rg.name
  admin_username                     = var.admin_username
  admin_password                     = random_password.admin_password.result
  disable_password_authentication    = false
  generate_admin_password_or_ssh_key = false
  os_type                            = "Linux"
  source_image_resource_id           = var.source_image_id
  sku_size                           = var.vmSku          
  custom_data                        = local.user_data_base64
  zone                               = null

  admin_ssh_keys = [
    {
      public_key = tls_private_key.this.public_key_openssh
      username   = var.admin_username #the username must match the admin_username currently.
    }
  ]

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
    disk_size_gb           = 128
    caching                = "ReadWrite"
    storage_account_type   = "Premium_LRS"
    # disk_encryption_set_id = azurerm_disk_encryption_set.this.id
  }

  role_assignments = {
    role_assignment_2 = {
      principal_id               = data.azurerm_client_config.current.client_id
      role_definition_id_or_name = "Virtual Machine Contributor"
      description                = "Assign the Virtual Machine Contributor role to the deployment user/sp on this virtual machine resource scope."
      principal_type             = "ServicePrincipal"
    }
   role_assignment_3 = {
      principal_id               = azurerm_user_assigned_identity.identity.principal_id
      role_definition_id_or_name = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/4633458b-17de-408a-b874-0445c86b69e6"  # Replace with the correct role definition ID
      description                = "Assign the User Identity, Secret User role."
      principal_type             = "ServicePrincipal"
   }
  }

  depends_on = [
    module.avm_res_keyvault_vault
  ]
}