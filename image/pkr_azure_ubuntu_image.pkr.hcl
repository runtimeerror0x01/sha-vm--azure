variables {
   pkr_subscription_id = "$(ARM_SUBSCRIPTION_ID)"
   pkr_client_id = "$(ARM_CLIENT_ID)"
   pkr_client_secret = "$(ARM_CLIENT_SECRET)"
   pkr_rg = "$(RG_NAME)"
   pkr_location = "$(LOCATION)"
   pkr_Image_name = "$(IMAGE_NAME)"
}

source "azure-arm" "ubuntu-22_4-test" {
   os_type = "Linux"
   image_publisher = "canonical"
   image_offer = "0001-com-ubuntu-server-jammy"
   image_sku = "22_04-lts-gen2"
   managed_image_name = var.pkr_Image_name
   managed_image_resource_group_name = var.pkr_rg
   location = var.pkr_location
   vm_size="Standard_B2ms"
   subscription_id = var.pkr_subscription_id
   client_id = var.pkr_client_id
   client_secret = var.pkr_client_secret
}

packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

build {
   name = "create_vm"
   sources = [
      "source.azure-arm.ubuntu-22_4-test",
   ]
   provisioner "shell" {
      script = "image/scripts/01_ubuntu_packages.sh"
   }
   # provisioner "shell" {
   #    script = "image/scripts/02_ubuntu_docker.sh"
   # }
   #   provisioner "shell" {
   #    script = "image/scripts/03_ubuntu_nodejs_yarn_maven_gradle.sh"
   # }
   # provisioner "shell" {
   #    script = "image/scripts/04_ubuntu_dotnet_Terraform_Bicep.sh"
   # }
   #    provisioner "shell" {
   #    script = "image/scripts/05_ubuntu_helm_kubectl.sh"
   # }
   #    provisioner "shell" {
   #    script = "image/scripts/06_ubuntu_Azcli_azd_pwsh_chrome.sh"
   # }
   #       provisioner "shell" {
   #    script = "image/scripts/07_ubuntu_googlechrome.sh"
   # }
   #    provisioner "shell" {
   #    script = "image/scripts/env.sh"
   # }
   
}