terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=5.0.0"
    }
  }

  # backend "azurerm" {
  #   resource_group_name  = "rg-storage-global"
  #   storage_account_name = "codeparceazure"
  #   container_name       = "tfstate"
  #   key                  = "az-serverless-security-lab.tfstate" 
  # }

}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = false
      recover_soft_deleted_secrets          = false
    }
  }
}
