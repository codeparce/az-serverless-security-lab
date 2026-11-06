resource "azurerm_application_insights" "insights" {
  name                = "card-api-${random_string.suffix.result}"

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  workspace_id        = var.azurerm_log_analytics_workspace_id
  application_type    = "Node.JS"
}