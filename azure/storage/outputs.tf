output "storage_account_id" {
  description = "ID del storage "
  value       = azurerm_storage_account.storage.id
}

output "storage_account_name" {
  description = "Nombre del storage "
  value       = azurerm_storage_account.storage.name
}

output "storage_container_url" {
  description = "Endpoint del contenedor de storage"
  value       = azurerm_storage_container.uploads.url
}


output "storage_container_id" {
  description = "ID del contenedor de storage"
  value       = azurerm_storage_container.uploads.id
}


output "azurerm_log_analytics_workspace_id" {
  description = "ID del workspace de Log Analytics"
  value       = azurerm_log_analytics_workspace.law.id
}