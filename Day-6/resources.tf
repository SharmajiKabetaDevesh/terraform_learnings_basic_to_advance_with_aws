
resource "azurerm_storage_account" "example"{
    for_each =var.storage_account_name
    name = var.storage_account_name[each.value]
    resource_group_name = azurerm_resource_group.example.name
    location = azurerm_resource_group.example.location
    account_tier = "Standard"
    account_replication_type = var.replication_type

    tags= {
        environment =  "Staging"
    }
}


