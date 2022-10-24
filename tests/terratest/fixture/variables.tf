variable "environment" {
  type        = string
  description = "Environment name"
}
variable "management_environment" {
  type        = string
  description = "Environment name"
}
variable "platform" {
  description = "platform e.g. nlv or lv"
  type        = string
}
variable "resource_group_name" {
  type        = string
  description = "AKS resource group name"
}
variable "location" {
  type        = string
  description = "Geo location where the resource to be deployed"
  default     = "uksouth"
}
variable "route_table_egress" {
  type = object({
    name                   = string
    route_prefixes         = list(string)
    next_hop_in_ip_address = list(string)
  })
  description = "Egress routetable config"
}
variable "subnet_aks_system" {
  type = object({
    name                = string
    resource_group_name = string
    address_prefixes    = list(string)
  })
  description = "aks system subnet config"
}
variable "subnet_aks_worker" {
  type = object({
    name                = string
    resource_group_name = string
    address_prefixes    = list(string)
  })
  description = "aks system subnet config"
}
variable "vnet_name" {
  type        = string
  description = "VNET where aks subnet lives"
}
variable "vnet_rg_name" {
  type        = string
  description = "VNET Resource Group Name"
}
variable "vnet_cidr" {
  type        = string
  description = "VNET where aks subnet lives"
}
variable "aks_cluster_admins_aad_group_ids" {
  type        = list(string)
  description = "AAD admin group ids"
}
variable "aks" {
  type = object({
    prefix                             = string
    kubernetes_version                 = string
    orchestrator_version               = string
    cluster_name                       = string
    agents_size                        = string
    os_disk_size_gb                    = number
    agents_min_count                   = number
    agents_max_count                   = number
    agents_max_pods                    = number
    worker_agents_size                 = string
    worker_os_disk_size_gb             = number
    worker_agents_min_count            = number
    worker_agents_max_count            = number
    worker_agents_max_pods             = number
    prometheus_worker_agents_size      = string
    prometheus_worker_os_disk_size_gb  = number
    prometheus_worker_agents_min_count = number
    prometheus_worker_agents_max_count = number
    prometheus_worker_agents_max_pods  = number
  })
  description = "aks config"
}
variable "managed_identity_aks_system_name" {
  type        = string
  description = "Managed identity for aks system components"
}
variable "managed_identity_aks_worker_name" {
  type        = string
  description = "Managed identity for aks worker components"
}
variable "role_definition_aks_system_name" {
  type        = string
  description = "Role definition name for aks system MI"
}
variable "nsg_common_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefixes    = list(string)
    destination_address_prefix = string
    description                = string
  }))
  default = []
}
variable "nsg_aks_system" {
  type = object({
    name = string
    custom_rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefixes    = list(string)
      destination_address_prefix = string
      description                = string
    }))
  })
  description = "aks system subnet config"
}
variable "nsg_aks_worker" {
  type = object({
    name = string
    custom_rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefixes    = list(string)
      destination_address_prefix = string
      description                = string
    }))
  })
  description = "aks system subnet config"
}
variable "agents_pool_name" {
  type        = string
  description = "sys agent pool name"
  default     = "sysagentpool"
}
variable "worker_agents_pool_name" {
  type        = string
  description = "App agent pool name"
  default     = "wrkagentpool"
}
variable "prometheus_worker_agents_pool_name" {
  type        = string
  description = "App agent pool name"
  default     = "prometheus"
}
variable "acr_name" {
  type        = string
  description = "Container registry name"
}
variable "acr_resource_group_name" {
  type        = string
  description = "Container registry resource group name"
}
variable "service_endpoints_for_worker" {
  description = "The list of Service endpoints to associate with the subnet."
  type        = list(string)
  default     = []
}
variable "only_critical_addons_enabled" {
  description = "Enabling this option will taint default node pool with CriticalAddonsOnly=true:NoSchedule"
  type        = bool
  default     = false
}
variable "log_analytics_workspace" {
  type        = string
  description = "Log analytics workspace name"
  default     = null
}
variable "enable_log_analytics_workspace" {
  type        = bool
  description = "enable log analytics workspace"
}
variable "workspace_resource_group_name" {
  type        = string
  description = "resource grpup where workspace is created"
  default     = null
}
variable "tags" {
  type = map(string)
}
