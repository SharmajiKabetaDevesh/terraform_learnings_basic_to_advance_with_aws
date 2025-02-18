 terraform{
    backend "azurerm" {
           resource_group_name = "devlearn715"
           storage_account_name="learntfbackedn715"
           container_name="tfstate"
           key="dev.terraform.tfstate"
    }
 }