# Azure Function Rol
# ------------------------
# STORAGE RBAC
resource "azurerm_role_assignment" "storage_blob" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_function_app_flex_consumption.alfa.identity[0].principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "storage_queue" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = azurerm_function_app_flex_consumption.alfa.identity[0].principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "storage_table" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Table Data Contributor"
  principal_id         = azurerm_function_app_flex_consumption.alfa.identity[0].principal_id
  principal_type       = "ServicePrincipal"
}

# KEY VAULT RBAC
resource "azurerm_role_assignment" "key_vault" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_function_app_flex_consumption.alfa.identity[0].principal_id
  principal_type       = "ServicePrincipal"
}

//Colaborador de datos de Storage Blob
//Publicador de métricas de supervisión
//Propietario de datos de Storage Blob