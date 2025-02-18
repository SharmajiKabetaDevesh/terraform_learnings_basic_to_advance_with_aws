terraform{
    required_providers{
        azurerm={
            source="hashicorp/azurerm"
            version="~> 4.8.0"
        }
    }
    
    backend "azurerm" {
           resource_group_name = "devlearn715"
           storage_account_name="learntfbackedn715"
           container_name="tfstate"
           key="dev.terraform.tfstate"
    }
    required_version=">= 1.1.0"
}
provider "azurerm"{
    features{}
}