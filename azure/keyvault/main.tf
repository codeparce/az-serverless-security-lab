data "azurerm_client_config" "current" {}

data "http" "my_ip" {
  url = "https://api.ipify.org"
}

##  Creacion del Key vault - publico
resource "azurerm_key_vault" "kv" {
  name                        = "keyVaultCodeparceLab"
  location                    = var.resource_group_location
  resource_group_name         = var.resource_group_name
  sku_name = "standard"

  // Habilitar RBAC para la autorización de acceso
  rbac_authorization_enabled = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id

  // Configuración de retención y protección de eliminación
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false 

  // Network access configuration
  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules      = [data.http.my_ip.body]
    virtual_network_subnet_ids = [
      var.subnet_id
    ]
  }

  tags = {
    env: "lab",
    terraform: true
  }
}


# Asignación del Rol: Administrador de Key Vault

resource "azurerm_role_assignment" "secrets_officer" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.user_object_id
}
