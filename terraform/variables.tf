variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group"
}

variable "location" {
  type        = string
  description = "Location of the Resource Group"
}

# Variables for Virtual Network
variable "virtual_network_name" {
  type        = string
  description = "Name of the Virtual Network"
}

variable "virtual_network_rg" {
  type        = string
  description = "Name of the Virtual Network Resource Group"
}

variable "subnet_name" {
  type        = string
  description = "Name of the Subnet"
}

variable "vm_name_prefix" {
  type        = string
  description = "List of VM names to deploy"
}

variable "managed_identity_name" {
  type        = string
  description = "Name of the Managed User Identity"
}

variable "keyvault_name" {
  type        = string
  description = "Name of the Key Vault"
}

variable "ssh_key_name" {
  type        = string
  description = "Name of the SSH Key Secret"
}

variable "admin_username" {
  type        = string
  description = "Virtual Machine Username"
}

variable "source_image_id" {
  type        = string
  description = "Name of the Custom Image to use."
}

variable "vmSku" {
  type        = string
  description = "Size of the VM "
}

variable "custom_data" {
  type        = string
  default     = null
  description = "(Optional) The Base64 encoded Custom Data for building this virtual machine. Changing this forces a new resource to be created"

  validation {
    condition     = var.custom_data == null ? true : can(base64decode(var.custom_data))
    error_message = "The `custom_data` must be either `null` or a valid Base64-Encoded string."
  }
}

variable "accelerated_networking_enabled" {
  type        = bool
  description = "Size of the VM "
}
