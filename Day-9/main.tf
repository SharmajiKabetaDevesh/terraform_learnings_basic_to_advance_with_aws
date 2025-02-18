terraform{
    required_providers {
      azurerm={
        source="hashicorp/azurerm"
        version="~> 4.8.0"
      }
    }
    required_version=">=1.1.0"
}

provider "azurerm"{
    features {
      
    }
}
resource "azurerm_resource_group" "resgroup" {
  name     = var.name_res_group
  location = var.location
}

