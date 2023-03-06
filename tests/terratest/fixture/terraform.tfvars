environment                    = "test"
management_environment         = "mdv"
platform                       = "nlv"
resource_group_name            = "RG-TEST-APPS01-01"
location                       = "uksouth"
log_analytics_workspace        = "LA-MDV-INT-WS"
enable_log_analytics_workspace = false
workspace_resource_group_name  = "RG-TEST-INT-01"
route_table_egress = {
  name                   = "UR-TEST-GATEWAY-APPS01-01"
  route_prefixes         = ["1.1.1.1/32"]
  next_hop_in_ip_address = ["10.88.112.100"]
}
subnet_aks_system = {
  name                = "SN-TEST-APPS01-SYS-01"
  resource_group_name = "RG-TEST-CORE-01"
  address_prefixes    = ["10.250.64.0/20"]
}
subnet_aks_worker = {
  name                = "SN-TEST-APPS01-APP-01"
  resource_group_name = "RG-TEST-CORE-01"
  address_prefixes    = ["10.250.0.0/18"]
}
vnet_name                        = "VN-TEST-APPS01-01"
vnet_rg_name                     = "RG-TEST-APPS01-01"
vnet_cidr                        = "10.250.0.0/16"
aks_cluster_admins_aad_group_ids = ["fab42284-7ec2-4026-9b00-9ca38287e5fb"]
aks = {
  prefix                             = "K8-TEST-APPS01-01"
  cluster_name                       = "K8-TEST-APPS01-01"
  kubernetes_version                 = "1.24.9"
  orchestrator_version               = "1.24.9"
  agents_size                        = "Standard_D4s_v3"
  os_disk_size_gb                    = 200
  agents_min_count                   = 2
  agents_max_count                   = 10
  agents_max_pods                    = 20
  worker_agents_size                 = "Standard_D4s_v3"
  worker_os_disk_size_gb             = 200
  worker_agents_min_count            = 2
  worker_agents_max_count            = 200
  worker_agents_max_pods             = 20
  prometheus_worker_agents_size      = "Standard_D8s_v3"
  prometheus_worker_os_disk_size_gb  = 200
  prometheus_worker_agents_min_count = 1
  prometheus_worker_agents_max_count = 1
  prometheus_worker_agents_max_pods  = 20
}
managed_identity_aks_system_name = "MI-TEST-APPS01-SYS-01"
managed_identity_aks_worker_name = "MI-TEST-APPS01-APP-01"
nsg_aks_system = {
  name         = "NS-TEST-APPS01-SYS-01"
  custom_rules = []
}
nsg_aks_worker = {
  name         = "NS-TEST-APPS01-APP-01"
  custom_rules = []
}
role_definition_aks_system_name = "RD-TEST-APPS01-SYS-01"
acr_name                        = "CRTESTREPO01"
acr_resource_group_name         = "RG-TEST-INT-ACR-01"
service_endpoints_for_worker    = ["Microsoft.Sql", "Microsoft.Storage"]
only_critical_addons_enabled    = true
tags = {
  environment = "test"
  project     = "aks"
}
