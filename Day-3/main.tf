terraform {
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


resource "azurerm_resource_group" "example"{
    name ="deveshrg"
    location = "West Europe"
}

resource "azurerm_storage_account" "example"{
    name = "devlearn634"
    resource_group_name = azurerm_resource_group.example.name
    location = azurerm_resource_group.example.location
    account_tier = "Standard"
    account_replication_type = "GRS"

    tags= {
        environment =  local.common_tags.environment
    }
}


variable "environment"{
    type=string
    description="the env type"
    default="staging"
}

output "storage_account_name"{
    value=azurerm_storage_account.example.id
}
locals{
    common_tags={
        environment="Dev"
        lob="banking"
        stage="alpha"
    }
}