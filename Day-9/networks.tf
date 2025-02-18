

resource "azurerm_virtual_network" "virtual_network" {
  name                = "example-network"
  location            = azurerm_resource_group.resgroup.location
  resource_group_name = azurerm_resource_group.resgroup.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]



  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.resgroup.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.2.0/20"]
}

resource "azurerm_network_security_group" "network_security_group" {
  name                = "example-security-group"
  location            = azurerm_resource_group.resgroup.location
  resource_group_name = azurerm_resource_group.resgroup.name
  security_rule {
    name ="SSH"
    priority = 102
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range ="*"
    destination_port_range="22"
    source_address_prefix = "*"
    destination_address_prefix="*"
  }
  
  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_LB_Health_Probe"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "50000-60000"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}


resource "azurerm_public_ip" "public_ip" {
  name                = "exposes_app_to_the_world"
  resource_group_name = azurerm_resource_group.resgroup.name
  location            = azurerm_resource_group.resgroup.location
  allocation_method   = "Static"
  zones=["1"]
  sku="Standard"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_lb" "load_balancer" {
  name                = "TestLoadBalancer"
  location            = azurerm_resource_group.resgroup.location
  resource_group_name = azurerm_resource_group.resgroup.name
  sku="Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "address_pool_to_look_for" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = "BackendPool"
}

resource "azurerm_lb_rule" "load_b_rule"{
   loadbalancer_id                = azurerm_lb.load_balancer.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids        = [azurerm_lb_backend_address_pool.address_pool_to_look_for.id]
  probe_id                        = azurerm_lb_probe.health_probe.id
}

resource "azurerm_lb_probe" "health_probe"{
   loadbalancer_id =azurerm_lb.load_balancer.id
   name="http-prob"
   protocol = "Http"
   port=80
   request_path = "/"
   interval_in_seconds = 5
   number_of_probes=2
}


resource "azurerm_lb_nat_rule" "ssh" {
  name                           = "ssh"
  resource_group_name            = azurerm_resource_group.resgroup.name
  loadbalancer_id                = azurerm_lb.load_balancer.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.address_pool_to_look_for.id
}



resource "azurerm_public_ip" "natgwpip" {
  name                = "natgw-publicIP"
  location            = azurerm_resource_group.resgroup.location
  resource_group_name = azurerm_resource_group.resgroup.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}




#add nat gateway to enable outbound traffic from the backend instances
resource "azurerm_nat_gateway" "example" {
  name                    = "nat-Gateway"
  location                = azurerm_resource_group.resgroup.location
  resource_group_name     = azurerm_resource_group.resgroup.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}

resource "azurerm_subnet_nat_gateway_association" "example" {
  subnet_id      = azurerm_subnet.subnet.id
  nat_gateway_id = azurerm_nat_gateway.example.id
}

# add nat gateway public ip association
resource "azurerm_nat_gateway_public_ip_association" "example" {
  public_ip_address_id = azurerm_public_ip.natgwpip.id
  nat_gateway_id       = azurerm_nat_gateway.example.id
}



resource "azurerm_linux_virtual_machine_scale_set" "example" {
  name                = "example-vmss"
  resource_group_name = azurerm_resource_group.resgroup.name
  location            = azurerm_resource_group.resgroup.location
  sku                 = "Standard_F2"
  instances           = 1
  admin_username      = "adminuser"
  user_data = base64encode(file("user-data.sh"))
  admin_ssh_key {
    username   = "adminuser"
    public_key = local.first_public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.address_pool_to_look_for.id]
    }
  
  }
}

