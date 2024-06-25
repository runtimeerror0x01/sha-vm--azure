location                      = "uksouth"

virtual_network_rg            = "ado-vnet"
virtual_network_name          = "packer-vnet"
subnet_name                   = "vmSubnet"

managed_identity_name         = "gitops-vm-identity"
keyvault_name                 = "gitops-vm-kv01"
ssh_key_name                  = "adminuser-ssh-private-key-prod"

vmSku                         = "Standard_B20ms"
vm_name_prefix                = "gitops-uksth-agent-prod"
                
