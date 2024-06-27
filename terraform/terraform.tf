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
    # resource_group_name   = "rg-TFStates"  // This is being dealt with in the terraform tasks in the pipeline
    # storage_account_name  = "aciadolnxtfstates"  
    # container_name        = "main"  
    # key                   = "vmadogent.tfstate"  
  }
}


provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false # This is to handle MCAPS or other policy driven resource creation.
    }
  }
  # storage_use_azuread = true
}