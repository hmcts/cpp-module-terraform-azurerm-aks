# provider "azurerm" {
#   features {}
# }

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.117.0"
    }
  }
}
data "azurerm_subscription" "current" {}

resource "random_id" "prefix" {
  byte_length = 8
}
resource "azurerm_resource_group" "aks" {
  name     = "${var.resource_group_name}-${random_id.prefix.hex}"
  location = var.location
}

resource "azurerm_virtual_network" "test_vn" {
  name                = "${var.vnet_name}-${random_id.prefix.hex}"
  address_space       = ["${var.vnet_cidr}"]
  location            = var.location
  resource_group_name = azurerm_resource_group.aks.name
}

resource "azurerm_private_dns_zone" "aks" {
  name                = "privatelink.uksouth.azmk8s.io"
  resource_group_name = azurerm_resource_group.aks.name
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.aks.name
  location            = var.location
  sku                 = "Premium"
  admin_enabled       = false
}

module "aks" {
  //source = "../tf_module.terraform-azurerm-aks"
  source                                      = "../../.."
  resource_group_name                         = azurerm_resource_group.aks.name
  location                                    = var.location
  prefix                                      = "${var.aks.prefix}-${random_id.prefix.hex}"
  identity_type                               = "UserAssigned"
  user_assigned_identity_id                   = azurerm_user_assigned_identity.aks_system.id
  kubernetes_version                          = var.aks.kubernetes_version
  orchestrator_version                        = var.aks.orchestrator_version
  cluster_name                                = "${var.aks.cluster_name}-${random_id.prefix.hex}"
  network_plugin                              = "azure"
  net_profile_outbound_type                   = "loadBalancer"
  vnet_subnet_id                              = module.subnet_aks_system.id
  private_dns_zone_id                         = azurerm_private_dns_zone.aks.id
  agents_size                                 = var.aks.agents_size
  os_disk_size_gb                             = var.aks.os_disk_size_gb
  sku_tier                                    = "Standard"
  enable_role_based_access_control            = true
  rbac_aad_admin_group_object_ids             = var.aks_cluster_admins_aad_group_ids
  rbac_aad_managed                            = true
  private_cluster_enabled                     = true
  enable_http_application_routing             = false # We will deploy Ingress separately
  enable_azure_policy                         = false
  enable_auto_scaling                         = true
  enable_host_encryption                      = true
  enable_log_analytics_workspace              = var.enable_log_analytics_workspace
  agents_min_count                            = var.aks.agents_min_count
  agents_max_count                            = var.aks.agents_max_count
  agents_count                                = null # Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes.
  agents_max_pods                             = var.aks.agents_max_pods
  agents_pool_name                            = var.agents_pool_name
  only_critical_addons_enabled                = var.only_critical_addons_enabled
  agents_availability_zones                   = ["1", "2"]
  agents_type                                 = "VirtualMachineScaleSets"
  kubelet_identity_client_id                  = azurerm_user_assigned_identity.aks_worker.client_id
  kubelet_identity_object_id                  = azurerm_user_assigned_identity.aks_worker.principal_id
  kubelet_user_assigned_identity_id           = azurerm_user_assigned_identity.aks_worker.id
  worker_orchestrator_version                 = var.aks.orchestrator_version
  worker_agents_pool_name                     = var.worker_agents_pool_name
  worker_agents_size                          = var.aks.worker_agents_size
  worker_os_disk_size_gb                      = var.aks.worker_os_disk_size_gb
  worker_vnet_subnet_id                       = module.subnet_aks_worker.id
  worker_enable_auto_scaling                  = true
  worker_agents_min_count                     = var.aks.worker_agents_min_count
  worker_agents_max_count                     = var.aks.worker_agents_max_count
  worker_agents_availability_zones            = ["1", "2"]
  worker_agents_max_pods                      = var.aks.worker_agents_max_pods
  worker_enable_host_encryption               = true
  prometheus_worker_orchestrator_version      = var.aks.orchestrator_version
  prometheus_worker_agents_pool_name          = var.prometheus_worker_agents_pool_name
  prometheus_worker_agents_size               = var.aks.prometheus_worker_agents_size
  prometheus_worker_os_disk_size_gb           = var.aks.prometheus_worker_os_disk_size_gb
  prometheus_worker_vnet_subnet_id            = module.subnet_aks_system.id
  prometheus_worker_enable_auto_scaling       = true
  prometheus_worker_agents_min_count          = var.aks.prometheus_worker_agents_min_count
  prometheus_worker_agents_max_count          = var.aks.prometheus_worker_agents_max_count
  prometheus_worker_agents_availability_zones = ["1", "2"]
  prometheus_worker_agents_max_pods           = var.aks.prometheus_worker_agents_max_pods
  prometheus_worker_enable_host_encryption    = true
  cluster_log_analytics_workspace_name        = var.log_analytics_workspace
  workspace_resource_group_name               = var.workspace_resource_group_name
  agents_labels = {
    "nodepool" : "control_plane_node"
  }
  agents_tags = {
    "Agent" : "control_plane_agent"
  }
  worker_agents_labels = {
    "nodepool" : "worker_node"
  }
  worker_agents_tags = {
    "Agent" : "worker_agent"
  }
  network_policy                 = "azure"
  net_profile_dns_service_ip     = "10.100.0.5"
  net_profile_docker_bridge_cidr = "172.18.0.1/16"
  net_profile_service_cidr       = "10.100.0.0/16"
  depends_on = [
    module.subnet_aks_system,
    time_sleep.role_assignment_propagation_wait_aks_system,
    azurerm_private_dns_zone.aks,
    azurerm_container_registry.acr
  ]
  tags = var.tags
}
