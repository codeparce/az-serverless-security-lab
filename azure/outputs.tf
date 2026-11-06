
output "kv" {
  value = module.kv
}

output "vnet" {
  value = module.vnet
}

output "stg" {
  value     = module.stg
}

output "funcapp" {
  value       = module.funcapp
  sensitive = true
}
