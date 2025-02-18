
resource "azurerm_storage_account" "example"{
    name = var.storage_account_name[0]
    resource_group_name = azurerm_resource_group.example.name
    location = azurerm_resource_group.example.location
    account_tier = "Standard"
    account_replication_type = var.replication_type
    # lifecycle {
    #   create_before_destroy=var.tobedestroyed_or_not
    # }
    # lifecycle {
    #   ignore_changes= all
      
    # }
    lifecycle{
        precondition {
         condition= var.allowed_locations[0]==azurerm_resource_group.example.location
         error_message= "This resource can be created only in Central India"
        }
    }
    tags= {
        environment =  "Staging"
    }
}


