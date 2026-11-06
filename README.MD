# Key Vault

## CLI

[Documentacion del CLI para el servicio Key Vault](https://learn.microsoft.com/es-es/cli/azure/keyvault/secret?view=azure-cli-latest#az-keyvault-secret-show)

```bash
## Obtener un secreto
az keyvault secret show --vault-name "key-vault-test-lab" -n "db-postgres-connection-string" -o  table

## Listar los secretos de un vault
az keyvault secret list --vault-name key-vault-test-lab --query "[].{name:name, value:value}" -o json

## descargar un secreto
az keyvault secret download -f .env  --vault-name key-vault-test-lab  -n "db-postgres-connection-string"
```

## Inyeccion de secretos en Funtion apps

[Usar referencias de Key Vault como configuración de la aplicación en Azure App Service, Azure Functions y Azure Logic Apps](https://learn.microsoft.com/es-es/azure/app-service/app-service-key-vault-references?tabs=azure-cli) 

# Terraform

```bash
set -a && source .env && set +a

terraform plan 

terraform apply

```

# Example cases

[Guia para implementacion de secretos en js](https://learn.microsoft.com/es-es/azure/key-vault/secrets/quick-create-node?tabs=azure-cli%2Cwindows&pivots=programming-language-javascript)

