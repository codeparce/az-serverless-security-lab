# VNet privada

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.resource_group_name}"
  address_space       = ["10.0.0.0/16"]
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "manager" {
  name                 = "subnet-private-manager"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  // Desactivar el acceso a internet para la subred
  default_outbound_access_enabled = false
  
  // Habilitar el endpoint de servicio para Key Vault
  service_endpoint {
    service = "Microsoft.KeyVault"
  }
  service_endpoint {
    service =  "Microsoft.Storage"
  }

  delegation {
    name = "flex-consumption-delegation"
    service_delegation {
      name = "Microsoft.App/environments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }

}