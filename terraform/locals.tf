locals {
  common_tags = {
   "BusinessUnit"  = "GMS"
   "Criticality"   = "CatC"
   "ServiceClass"  = "Bronze"
   "OpsCommitment" = "Core Hours"
   "ServiceName"   = "DC"
   "Cost Centre"    = "UKCSP00060"
    "DR"            = "N/A"
    "Owner"         = "Adrian.Rotermund@computacenter.com"
    "Approver"      = "Iain.Abraham@computacenter.com"
  }
  region = var.location 
  source_image_reference = {
    publisher = "canonical"                            # Replace with your custom image publisher
    offer     = "0001-com-ubuntu-server-jammy"         # Replace with your custom image offer
    sku       = "22_04-lts-gen2"                       # Replace with your custom image SKU
    version   = "latest"                               # Replace with the version of your custom image
  }

  vm_names = [
    for i in range(1, var.vm_count + 1) : format("%s-%02d", var.vm_name, i)
  ]

}

