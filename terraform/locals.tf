locals {
     tags = {
   "BusinessUnit"  = "GMS"
   "Criticality"   = "CatC"
   "ServiceClass"  = "Bronze"
   "OpsCommitment" = "Core Hours"
   "ServiceName"   = "DC"
   "Cost Centre"    = "UKCSP00060"
    "DR"            = "N/A"
    "Owner"         = ""
    "Approver"      = ""
  }
  region = var.location 
  source_image_reference = {
    publisher = "canonical"                            # Replace with your custom image publisher
    offer     = "0001-com-ubuntu-server-jammy"         # Replace with your custom image offer
    sku       = "22_04-lts-gen2"                       # Replace with your custom image SKU
    version   = "latest"                               # Replace with the version of your custom image
  }

  user_data_base64 = base64encode(data.local_file.cloud_init.content)

}

