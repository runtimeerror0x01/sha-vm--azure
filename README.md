
# Self-Hosted Virtual Machine Agent Deployment on Azure DevOps Pool

This repository is designed to deploy a Self-Hosted Virtual Machine agent in an Azure DevOps pool. The deployment pipeline consists of three main parts:

1. **Custom Image Creation**: Utilizes a Packer template to create a custom VM image.
2. **VM Provisioning**: Provisions the VM along with other necessary resources such as NIC, Managed User Identity, Key Vault, SSH key/password, etc.
3. **Agent Configuration**: Configures the agent as a service on the VM.

## Pipeline Configuration

Since the Terraform state file is stored in a separate subscription, which may have a different service principal for authorization than the subscription where resources are deployed, the following values are required:

### Backend Configuration
- `backend_service_connection_name`: [Your Backend Service Connection Name]
- `backend_subscription_name`: [Your Backend Subscription Name]
- `backend_subscription_id`: [Your Backend Subscription ID]
- `backend_resource_group_name`: [Your Backend Resource Group Name]
- `backend_resource_group_location`: [Your Backend Resource Group Location]
- `backend_storage_account_name`: [Your Backend Storage Account Name]
- `backend_storage_container_name`: main
- `default_tfstate_file_name`: [Your Default TFState File Name]

### Target Subscription Configuration
- `target_service_connection_name`: [Your Target Service Connection Name]
- `target_subscription_id`: [Your Target Subscription ID]
- `target_tfvars_path`: $(System.DefaultWorkingDirectory)/terraform/environments/
- `terraform_path`: $(Build.SourcesDirectory)/terraform
- `notify_email`: [Notification Email]

## Environment-Specific Configuration

Supply the following values in both `dev.tfvars` and `env.tfvars` files located in the `terraform/environments` folder:

### dev.tfvars / env.tfvars
location                            = "[Your Location]"

virtual_network_rg                  = "[Your Virtual Network Resource Group]"
virtual_network_name                = "[Your Virtual Network Name]"
subnet_name                         = "[Your Subnet Name]"

managed_identity_name               = "[Your Managed Identity Name]"
keyvault_name                       = "[Your Key Vault Name]"
ssh_key_name                        = "[Your SSH Key Name]"

vmSku                               = "[Your VM SKU]"
vm_name_prefix                      = "[Your VM Name Prefix]"
accelerated_networking_enabled      = [true/false]

## Variable Group Configuration

Add the following key/value pairs to the Variable group named "vmSecrets":

### vmSecrets Variable Group

- `AZP_TOKEN`: [Your PAT Token]
- `AZP_URL`: [Your Organization Name]
- `AZP_POOL`: [Your Agent Pool Name]
- `AZP_AGENT_NAME`: [Your desired Agent Name]
- `VMUSER`: [Virtual Machine Username]
- `DevopsProjectName`: [The Azure DevOps Project Name where the code resides]
- `IMAGE_NAME`: [Your Desired Name of the Custom Image]
- `LOCATION`: [Region where the resource will be deployed]
- `RG_NAME`: [Desired Resource Group Name for all the resources]

Please add the credentials of the Service Principal which will be used to deploy the resources, this is required by the packer template to create the custom image.
- `ARM_CLIENT_ID`: [Your ARM Client ID]
- `ARM_CLIENT_SECRET`: [Your ARM Client Secret]
- `ARM_SUBSCRIPTION_ID`: [Your ARM Subscription ID]
- `ARM_TENANT_ID`: [Your ARM Tenant ID]

## Azure Verified Module

This repository uses an Azure Verified module to provision the resources. You can find the child module following the link below, referenced by the root module in the `terraform` folder. Additional configuration can be added to the root module by referencing the appropriate keys present in the child module.

### Child Module Reference
[Azure Verified Module - Compute Virtual Machine](https://github.com/Azure/terraform-azurerm-avm-res-compute-virtualmachine/blob/main/main.linux_vm.tf)

