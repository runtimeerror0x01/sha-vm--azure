terraform {
  required_version = "~> 1.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.105"
    }
    # random = {
    #   source  = "hashicorp/random"
    #   version = "~> 3.5"
    # }
  }
  backend "azurerm" {   
    resource_group_name   = "rg-TFStates"  # Replace with your resource group name
    storage_account_name  = "aciadolnxtfstates"  # Replace with your storage account name
    container_name        = "main"  # Replace with your container name
    key                   = "vmadogent.tfstate"  # Replace with your desired state file name
  }
}

# terraform {
#   backend "azurerm" {
#   }
# }

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false # This is to handle MCAPS or other policy driven resource creation.
    }
  }
  storage_use_azuread = true
}