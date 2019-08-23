resource "azurerm_resource_group" "nsgs1" {
   name         = "Lab-Core-RG"
   location     = "${var.loc}"
   tags         = "${var.tags}"
}

resource "azurerm_public_ip" "vpnGatewayPublicIp" {
  name                = "vpnGatewayPublicIp"
  location            = "${azurerm_resource_group.nsgs1.location}"
  resource_group_name = "${azurerm_resource_group.nsgs1.name}"
  tags                = "${azurerm_resource_group.nsgs1.tags}"
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network" "core" {
  name                = "Lab-Core-virtualNetwork1"
  location            = "${azurerm_resource_group.nsgs1.location}"
  resource_group_name = "${azurerm_resource_group.nsgs1.name}"
  tags                = "${azurerm_resource_group.nsgs1.tags}"
  address_space       = ["10.20.0.0/22"]
  dns_servers         = ["1.1.1.1", "1.0.0.1"]
  
  subnet {
    name           = "GatewaySubnet"
    address_prefix = "10.20.0.0/24"
  }

  subnet {
    name           = "training"
    address_prefix = "10.20.1.0/24"
  }

  subnet {
    name           = "dev"
    address_prefix = "10.20.2.0/24"
  }
} 

/*resource "azurerm_subnet" "dev" {
   name                 = "dev"
   virtual_network_name = "${azurerm_virtual_network.core.name}"
   resource_group_name = "${azurerm_resource_group.nsgs1.name}"
   address_prefix       = "10.20.2.0/24"
} */

# resource "azurerm_virtual_network_gateway" "vpnGateway" {
#     name                = "vpnGateway"
#     location            = "${azurerm_resource_group.core.location}"
#     resource_group_name = "${azurerm_resource_group.core.name}"
#     tags                = "${azurerm_resource_group.core.tags}"
# 
#     type                = "Vpn"
#     vpn_type            = "RouteBased"
# 
#     sku                 = "Basic"
#     enable_bgp          = true
# 
#     ip_configuration {
#         name                            = "vpnGwConfig"
#         public_ip_address_id            = "${azurerm_public_ip.vpnGatewayPublicIp.id}"
#         private_ip_address_allocation   = "Dynamic"
#         subnet_id                       = "${azurerm_subnet.GatewaySubnet.id}"
#     }
# 
# }