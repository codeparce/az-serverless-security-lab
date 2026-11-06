# outputs.tf
output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_manager_id" {
  value = azurerm_subnet.manager.id
}
