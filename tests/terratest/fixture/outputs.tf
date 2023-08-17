output "test_aks_id" {
  sensitive = true
  value     = module.aks.aks_id
}

output "test_admin_host" {
  sensitive = true
  value     = module.aks.admin_host
}

output "test_kube_raw" {
  sensitive = true
  value     = module.aks.kube_config_raw
}

output "random_id" {
  value = random_id.prefix.hex
}

output "resource_group_name" {
  value = azurerm_resource_group.aks.name
}

output "subscription_id" {
  value = data.azurerm_subscription.current.subscription_id
}
