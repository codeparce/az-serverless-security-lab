resource "azurerm_resource_group" "rg" {
  name     = "func-serverless-security-lab"
  location = "East US"
}

# Random suffix
resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

# Service Plan (Flex Consumption)
resource "azurerm_service_plan" "asp" {
  name                = "card-api-plan-${random_string.suffix.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "FC1" 
}

# Azure Function App
resource "azurerm_function_app_flex_consumption" "alfa" {
  name                = "card-api-${random_string.suffix.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  service_plan_id = azurerm_service_plan.asp.id

  // Configuración Storage Account 
  storage_container_type     = "blobContainer"
  storage_container_endpoint = var.storage_container_url
  storage_authentication_type = "SystemAssignedIdentity"

  // Configuración de instancia
  runtime_name    = "node"
  runtime_version = "24"
  maximum_instance_count = 40
  instance_memory_in_mb  = 2048
  
  // Configuración de red
  https_only = true
  virtual_network_subnet_id = var.subnet_id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    
    application_insights_key = azurerm_application_insights.insights.instrumentation_key
    application_insights_connection_string = azurerm_application_insights.insights.connection_string

    app_service_logs {
      disk_quota_mb = 40 
      retention_period_days = 10
    }

    minimum_tls_version = "1.2"
  } 

  app_settings = {
    "AzureWebJobsStorage"                  = ""
    "AzureWebJobsStorage__accountName"     = var.storage_account_name
    "AzureWebJobsStorage__credential"      = "managedidentity"

    "FUNCTIONS_NODE_BLOCK_ON_ENTRY_POINT_ERROR" = "true"
    "KEYVAULT_URL" = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=key-vault-uri)"
    "DB_CONNECTION" = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=db-connection)"
    "ENV" = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=test)"
  }

}
