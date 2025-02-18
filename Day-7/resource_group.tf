resource "azurerm_resource_group" "example"{
    name ="deveshrg"
    location = var.allowed_locations[0]
}
