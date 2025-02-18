
resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = "autoscale"
  location            = azurerm_resource_group.resgroup.location
  resource_group_name = azurerm_resource_group.resgroup.name
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.example.id
  enabled             = true
  profile {
    name = "autoscale"
    capacity {
      default = 1
      minimum = 1
      maximum = 2
    }

    
  }
}