resource "azurerm_application_insights" "insights" {
  for_each            = var.function
  name                = "${each.value.name}-${random_id.suffix.hex}"

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  workspace_id        = var.azurerm_log_analytics_workspace_id
  application_type    = "Node.JS"
}