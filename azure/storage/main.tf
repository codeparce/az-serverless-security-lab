# Random suffix
resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

# Storage Account
resource "azurerm_storage_account" "storage" {
  name                = "storagefunctions${random_string.suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location


  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"


  // Reglas de red para restringir el acceso
  allow_nested_items_to_be_public = false

  public_network_access_enabled = true
  # network_rules {
  #   default_action = "Deny"
  #   bypass = ["AzureServices", "Logging", "Metrics"]
  #   ip_rules = [ var.ip_address ]
  #   virtual_network_subnet_ids = [ var.subnet_id ]
  # }

  blob_properties {
    versioning_enabled = false
  }
  
  tags = {
    env: "lab",
    terraform: true
  }

}

resource "azurerm_storage_container" "uploads" {
  name                  = "uploads"
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
}
