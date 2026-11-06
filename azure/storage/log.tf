resource "azurerm_log_analytics_workspace" "law" {
  name                = "workspaces-${random_string.suffix.result}-lab"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}