terraform{
    required_providers {
      azurerm={
        source="hashicorp/azurerm"
        version="~> 4.8.0"
      }
    
    }
    required_version = ">=1.1.0"
}

provider "azurerm"{
    features {
      
    }
}

variable "roleid" {
    type=string
 
    default="6cd6252e-e152-4c97-5920-214da55c5afc"
  
}

variable "password" {
    type=string
    
    default="cec02bd5-f59a-0aa3-33a6-abd0bbf7e768"
  
}
provider "vault"{
   address="http://74.225.177.249:8200"
   skip_child_token = true
   auth_login{
    path = "auth/approle/login"
    parameters={
         role_id = "6cd6252e-e152-4c97-5920-214da55c5afc"
         secret_id="19ed7f6c-f90d-c3eb-d7c4-85195a0f565d"
          }
   }
}

data "vault_kv_secret_v2" "example" {
  mount ="kv"
  name  = "devsecrets"
}

output "dev"{
    
    sensitive = true
    value=data.vault_kv_secret_v2.example.data["username"]
}