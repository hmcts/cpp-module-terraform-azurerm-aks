locals {
  vault_ssh_key_path_private = "${var.vault_ssh_key_path_root}/${var.cluster_name}/aks_private_key"
  vault_ssh_key_path_public  = "${var.vault_ssh_key_path_root}/${var.cluster_name}/aks_public_key"
}

data "vault_generic_secret" "aks_public_key" {
  count = var.create_ssh_key ? 0 : 1
  path  = local.vault_ssh_key_path_public
}

module "ssh-key" {
  source                     = "./modules/ssh-key"
  count                      = var.create_ssh_key ? 1 : 0
  vault_ssh_key_path_private = local.vault_ssh_key_path_private
  vault_ssh_key_path_public  = local.vault_ssh_key_path_public
}

resource "azurerm_kubernetes_cluster" "main" {
  name                    = var.cluster_name == null ? "${var.prefix}-aks" : var.cluster_name
  kubernetes_version      = var.kubernetes_version
  location                = var.location
  resource_group_name     = var.resource_group_name
  dns_prefix              = var.prefix
  sku_tier                = var.sku_tier
  private_cluster_enabled = var.private_cluster_enabled
  private_dns_zone_id     = var.private_dns_zone_id

  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      # remove any new lines using the replace interpolation function
      key_data = replace(
        var.create_ssh_key ? module.ssh-key.0.public_ssh_key : data.vault_generic_secret.aks_public_key.0.data.value, "\n", ""
      )
    }
  }

  dynamic "default_node_pool" {
    for_each = var.enable_auto_scaling == true ? [] : ["default_node_pool_manually_scaled"]
    content {
      orchestrator_version         = var.orchestrator_version
      name                         = var.agents_pool_name
      node_count                   = var.agents_count
      vm_size                      = var.agents_size
      os_disk_size_gb              = var.os_disk_size_gb
      vnet_subnet_id               = var.vnet_subnet_id
      enable_auto_scaling          = var.enable_auto_scaling
      max_count                    = null
      min_count                    = null
      enable_node_public_ip        = var.enable_node_public_ip
      availability_zones           = var.agents_availability_zones
      node_labels                  = var.agents_labels
      type                         = var.agents_type
      tags                         = merge(var.tags, var.agents_tags)
      max_pods                     = var.agents_max_pods
      enable_host_encryption       = var.enable_host_encryption
      only_critical_addons_enabled = var.only_critical_addons_enabled
    }
  }

  dynamic "default_node_pool" {
    for_each = var.enable_auto_scaling == true ? ["default_node_pool_auto_scaled"] : []
    content {
      orchestrator_version         = var.orchestrator_version
      name                         = var.agents_pool_name
      vm_size                      = var.agents_size
      os_disk_size_gb              = var.os_disk_size_gb
      vnet_subnet_id               = var.vnet_subnet_id
      enable_auto_scaling          = var.enable_auto_scaling
      max_count                    = var.agents_max_count
      min_count                    = var.agents_min_count
      enable_node_public_ip        = var.enable_node_public_ip
      availability_zones           = var.agents_availability_zones
      node_labels                  = var.agents_labels
      type                         = var.agents_type
      tags                         = merge(var.tags, var.agents_tags)
      max_pods                     = var.agents_max_pods
      enable_host_encryption       = var.enable_host_encryption
      only_critical_addons_enabled = var.only_critical_addons_enabled
    }
  }

  dynamic "service_principal" {
    for_each = var.client_id != "" && var.client_secret != "" ? ["service_principal"] : []
    content {
      client_id     = var.client_id
      client_secret = var.client_secret
    }
  }

  dynamic "identity" {
    for_each = var.client_id == "" || var.client_secret == "" ? ["identity"] : []
    content {
      type                      = var.identity_type
      user_assigned_identity_id = var.user_assigned_identity_id
    }
  }

  dynamic "kubelet_identity" {
    for_each = var.kubelet_user_assigned_identity_id != "" || var.kubelet_identity_client_id != "" || var.kubelet_identity_object_id != "" ? ["kubelet_identity"] : []
    content {
      client_id                 = var.kubelet_identity_client_id
      object_id                 = var.kubelet_identity_object_id
      user_assigned_identity_id = var.kubelet_user_assigned_identity_id
    }
  }

  addon_profile {
    http_application_routing {
      enabled = var.enable_http_application_routing
    }

    kube_dashboard {
      enabled = var.enable_kube_dashboard
    }

    azure_policy {
      enabled = var.enable_azure_policy
    }

    oms_agent {
      enabled                    = var.enable_log_analytics_workspace
      log_analytics_workspace_id = var.enable_log_analytics_workspace ? data.azurerm_log_analytics_workspace.main[0].id : null
    }
  }

  role_based_access_control {
    enabled = var.enable_role_based_access_control

    dynamic "azure_active_directory" {
      for_each = var.enable_role_based_access_control && var.rbac_aad_managed ? ["rbac"] : []
      content {
        managed                = true
        admin_group_object_ids = var.rbac_aad_admin_group_object_ids
      }
    }

    dynamic "azure_active_directory" {
      for_each = var.enable_role_based_access_control && !var.rbac_aad_managed ? ["rbac"] : []
      content {
        managed           = false
        client_app_id     = var.rbac_aad_client_app_id
        server_app_id     = var.rbac_aad_server_app_id
        server_app_secret = var.rbac_aad_server_app_secret
      }
    }
  }

  network_profile {
    network_plugin     = var.network_plugin
    network_policy     = var.network_policy
    dns_service_ip     = var.net_profile_dns_service_ip
    docker_bridge_cidr = var.net_profile_docker_bridge_cidr
    outbound_type      = var.net_profile_outbound_type
    pod_cidr           = var.net_profile_pod_cidr
    service_cidr       = var.net_profile_service_cidr
  }

  tags = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "main" {
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.main.id
  orchestrator_version   = var.worker_orchestrator_version
  name                   = var.worker_agents_pool_name
  vm_size                = var.worker_agents_size
  os_disk_size_gb        = var.worker_os_disk_size_gb
  vnet_subnet_id         = var.worker_vnet_subnet_id
  enable_auto_scaling    = var.worker_enable_auto_scaling
  max_count              = var.worker_agents_max_count
  min_count              = var.worker_agents_min_count
  enable_node_public_ip  = var.worker_enable_node_public_ip
  availability_zones     = var.worker_agents_availability_zones
  node_labels            = var.worker_agents_labels
  max_pods               = var.worker_agents_max_pods
  enable_host_encryption = var.worker_enable_host_encryption
  tags                   = merge(var.tags, var.worker_agents_tags)
}

data "azurerm_log_analytics_workspace" "main" {
  count               = var.enable_log_analytics_workspace ? 1 : 0
  name                = var.cluster_log_analytics_workspace_name
  resource_group_name = var.workspace_resource_group_name
}
