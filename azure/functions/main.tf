resource "azurerm_resource_group" "rg" {
  name     = "func-serverless-security-lab"
  location = "East US"
}

# Random suffix
resource "random_id" "suffix" {
  byte_length = 3 
}

variable "function" {
  default = {
    "user" = { name = "user-api" }
    "card"  = { name = "card-api"}
  }
}

# Service Plan (Flex Consumption)
resource "azurerm_service_plan" "asp" {
  for_each            = var.function
  name                = "${each.value.name}-plan-${random_id.suffix.hex}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "FC1"
}

# Azure Function App
resource "azurerm_function_app_flex_consumption" "alfa" {
  for_each            = var.function
  name                = "${each.value.name}-${random_id.suffix.hex}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  service_plan_id = azurerm_service_plan.asp[each.key].id

  // Configuración Storage Account 
  storage_container_type      = "blobContainer"
  storage_container_endpoint  = var.storage_container_url
  storage_authentication_type = "SystemAssignedIdentity"

  // Configuración de instancia
  runtime_name           = "node"
  runtime_version        = "24"
  maximum_instance_count = 40
  instance_memory_in_mb  = 2048

  // Configuración de red
  https_only                = true
  virtual_network_subnet_id = var.subnet_id

  identity {
    type = "SystemAssigned"
  }

  site_config {

    app_service_logs {
      disk_quota_mb         = 40
      retention_period_days = 10
    }

    minimum_tls_version = "1.2"
  }

  app_settings = {
    "AzureWebJobsStorage"              = ""
    "AzureWebJobsStorage__accountName" = var.storage_account_name
    "AzureWebJobsStorage__credential"  = "managedidentity"

    # Mueve las conexiones de Insights aquí para un control plano de variables de entorno
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.insights[each.key].instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.insights[each.key].connection_string

    "FUNCTIONS_NODE_BLOCK_ON_ENTRY_POINT_ERROR" = "true"
    "KEYVAULT_URL"                              = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=key-vault-uri)"
    "DB_CONNECTION"                             = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=db-connection)"
    "ENV"                                       = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=test)"
  }

}
