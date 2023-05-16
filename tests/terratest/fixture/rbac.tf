resource "azurerm_user_assigned_identity" "aks_system" {
  name                = "${var.managed_identity_aks_system_name}-${random_id.prefix.hex}"
  resource_group_name = azurerm_resource_group.aks.name
  location            = var.location
  tags                = var.tags
}
resource "azurerm_user_assigned_identity" "aks_worker" {
  name                = "${var.managed_identity_aks_worker_name}-${random_id.prefix.hex}"
  resource_group_name = azurerm_resource_group.aks.name
  location            = var.location
  tags                = var.tags
}
resource "azurerm_role_definition" "aks_system_managed_identity" {
  name        = "${var.role_definition_aks_system_name}-${random_id.prefix.hex}"
  scope       = data.azurerm_subscription.current.id
  description = "Role definition to allow MI assign action"
  permissions {
    actions = [
      "Microsoft.ManagedIdentity/userAssignedIdentities/assign/action",
    ]
    not_actions = []
  }
  assignable_scopes = [
    data.azurerm_subscription.current.id,
  ]
}
resource "azurerm_role_assignment" "aks_system_private_dns" {
  scope                = azurerm_private_dns_zone.aks.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_system.principal_id
}
resource "azurerm_role_assignment" "aks_system_vnet" {
  scope                = azurerm_virtual_network.test_vn.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_system.principal_id
}
resource "azurerm_role_assignment" "aks_system_managed_identity" {
  scope              = azurerm_user_assigned_identity.aks_worker.id
  role_definition_id = azurerm_role_definition.aks_system_managed_identity.role_definition_resource_id
  principal_id       = azurerm_user_assigned_identity.aks_system.principal_id
}
resource "azurerm_role_assignment" "aks_worker_acr" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.aks_worker.principal_id
}
resource "time_sleep" "role_assignment_propagation_wait_aks_system" {
  depends_on = [
    azurerm_role_assignment.aks_system_private_dns,
    azurerm_role_assignment.aks_system_vnet,
    azurerm_role_assignment.aks_system_managed_identity,
    azurerm_role_assignment.aks_worker_acr,
  ]
  create_duration = "360s"
}
