resource "azurerm_resource_group" "rg" {
  name     = "az-serverless-security-lab"
  location = "East US"
}

data "http" "my_ip" {
  url = "https://api.ipify.org"
}


module "vnet" {
  source                  = "./vnet"
  resource_group_location = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
}

module "kv" {
  source                  = "./keyvault"
  resource_group_location = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name

  user_object_id = var.user_object_id
  subnet_id      = module.vnet.subnet_manager_id
}

module "stg" {
  source                  = "./storage"
  resource_group_location = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name

  ip_address = data.http.my_ip.body
  subnet_id  = module.vnet.subnet_manager_id
}

module "funcapp" {
  source = "./functions"

  storage_account_id    = module.stg.storage_account_id
  storage_account_name  = module.stg.storage_account_name
  storage_container_url = module.stg.storage_container_url
  storage_container_id  = module.stg.storage_container_id

  azurerm_log_analytics_workspace_id = module.stg.azurerm_log_analytics_workspace_id

  key_vault_uri  = module.kv.key_vault_uri
  key_vault_id   = module.kv.key_vault_id
  key_vault_name = module.kv.key_vault_name

  subnet_id = module.vnet.subnet_manager_id

  depends_on = [module.stg]
}
