variable "resource_group_name" {
  description = "The resource group name to be imported"
  type        = string
}

variable "location" {
  type        = string
  description = "Geo location where the resource to be deployed"
  default     = "uksouth"
}

variable "cluster_name" {
  description = "(Optional) The name for the AKS resources created in the specified Azure Resource Group. This variable overwrites the 'prefix' var (The 'prefix' var will still be applied to the dns_prefix if it is set)"
  type        = string
  default     = null
}

variable "cluster_log_analytics_workspace_name" {
  description = "(Optional) The name of the Analytics workspace"
  type        = string
  default     = null
}

variable "prefix" {
  description = "(Required) The prefix for the resources created in the specified Azure Resource Group"
  type        = string
}

variable "client_id" {
  description = "(Optional) The Client ID (appId) for the Service Principal used for the AKS deployment"
  type        = string
  default     = ""
}

variable "client_secret" {
  description = "(Optional) The Client Secret (password) for the Service Principal used for the AKS deployment"
  type        = string
  default     = ""
}

variable "kubelet_identity_client_id" {
  description = "(Optional) The Client ID of the User assigned managed identity used by kubelet"
  type        = string
  default     = ""
}

variable "kubelet_identity_object_id" {
  description = "(Optional) The Object ID of the User assigned managed identity used by kubelet"
  type        = string
  default     = ""
}

variable "kubelet_user_assigned_identity_id" {
  description = "(Optional) The Resource ID of the User assigned managed identity used by kubelet"
  type        = string
  default     = ""
}

variable "admin_username" {
  default     = "azureuser"
  description = "The username of the local administrator to be created on the Kubernetes cluster"
  type        = string
}

variable "agents_size" {
  default     = "Standard_D2s_v3"
  description = "The default virtual machine size for the Kubernetes agents"
  type        = string
}

variable "log_analytics_workspace_sku" {
  description = "The SKU (pricing level) of the Log Analytics workspace. For new subscriptions the SKU should be set to PerGB2018"
  type        = string
  default     = "PerGB2018"
}

variable "log_retention_in_days" {
  description = "The retention period for the logs in days"
  type        = number
  default     = 30
}

variable "agents_count" {
  description = "The number of Agents that should exist in the Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes."
  type        = number
  default     = 2
}

variable "vault_ssh_key_path_root" {
  description = "Vault path for ssh key to control access to the AKS cluster. Root path in vault for example secret/mgmt or secret/dev"
  type        = string
  default     = "secret/mgmt"
}

variable "tags" {
  type        = map(string)
  description = "Any tags that should be present on the Virtual Network resources"
  default     = {}
}

variable "enable_log_analytics_workspace" {
  type        = bool
  description = "Enable the creation of azurerm_log_analytics_workspace and azurerm_log_analytics_solution or not"
  default     = true
}

variable "vnet_subnet_id" {
  description = "(Optional) The ID of a Subnet where the Kubernetes Node Pool should exist. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "os_disk_size_gb" {
  description = "Disk size of nodes in GBs."
  type        = number
  default     = 50
}

variable "private_cluster_enabled" {
  description = "If true cluster API server will be exposed only on internal IP address and available only in cluster vnet."
  type        = bool
  default     = false
}

variable "private_dns_zone_id" {
  description = "Private dns zone id in BYO scenario. The default will create a private dns zone with random GUID."
  type        = string
  default     = null
}

variable "enable_kube_dashboard" {
  description = "Enable Kubernetes Dashboard."
  type        = bool
  default     = false
}

variable "enable_http_application_routing" {
  description = "Enable HTTP Application Routing Addon (forces recreation)."
  type        = bool
  default     = false
}

variable "enable_azure_policy" {
  description = "Enable Azure Policy Addon."
  type        = bool
  default     = false
}

variable "sku_tier" {
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid"
  type        = string
  default     = "Free"
}

variable "enable_role_based_access_control" {
  description = "Enable Role Based Access Control."
  type        = bool
  default     = false
}

variable "rbac_aad_managed" {
  description = "Is the Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration."
  type        = bool
  default     = false
}

variable "rbac_aad_admin_group_object_ids" {
  description = "Object ID of groups with admin access."
  type        = list(string)
  default     = null
}

variable "rbac_aad_client_app_id" {
  description = "The Client ID of an Azure Active Directory Application."
  type        = string
  default     = null
}

variable "rbac_aad_server_app_id" {
  description = "The Server ID of an Azure Active Directory Application."
  type        = string
  default     = null
}

variable "rbac_aad_server_app_secret" {
  description = "The Server Secret of an Azure Active Directory Application."
  type        = string
  default     = null
}

variable "network_plugin" {
  description = "Network plugin to use for networking."
  type        = string
  default     = "kubenet"
}

variable "network_policy" {
  description = " (Optional) Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are calico and azure. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "net_profile_dns_service_ip" {
  description = "(Optional) IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "net_profile_docker_bridge_cidr" {
  description = "(Optional) IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "net_profile_outbound_type" {
  description = "(Optional) The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are loadBalancer and userDefinedRouting. Defaults to loadBalancer."
  type        = string
  default     = "loadBalancer"
}

variable "net_profile_pod_cidr" {
  description = " (Optional) The CIDR to use for pod IP addresses. This field can only be set when network_plugin is set to kubenet. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "net_profile_service_cidr" {
  description = "(Optional) The Network Range used by the Kubernetes service. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "kubernetes_version" {
  description = "Specify which Kubernetes release to use. The default used is the latest Kubernetes version available in the region"
  type        = string
  default     = null
}

variable "orchestrator_version" {
  description = "Specify which Kubernetes release to use for the orchestration layer. The default used is the latest Kubernetes version available in the region"
  type        = string
  default     = null
}

variable "enable_auto_scaling" {
  description = "Enable node pool autoscaling"
  type        = bool
  default     = false
}

variable "agents_max_count" {
  type        = number
  description = "Maximum number of nodes in a pool"
  default     = null
}

variable "agents_min_count" {
  type        = number
  description = "Minimum number of nodes in a pool"
  default     = null
}

variable "agents_pool_name" {
  description = "The default Azure AKS agentpool (nodepool) name."
  type        = string
  default     = "nodepool"
}

variable "enable_node_public_ip" {
  description = "(Optional) Should nodes in this Node Pool have a Public IP Address? Defaults to false."
  type        = bool
  default     = false
}

variable "agents_availability_zones" {
  description = "(Optional) A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created."
  type        = list(string)
  default     = null
}

variable "agents_labels" {
  description = "(Optional) A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. Changing this forces a new resource to be created."
  type        = map(string)
  default     = {}
}

variable "agents_type" {
  description = "(Optional) The type of Node Pool which should be created. Possible values are AvailabilitySet and VirtualMachineScaleSets. Defaults to VirtualMachineScaleSets."
  type        = string
  default     = "VirtualMachineScaleSets"
}

variable "agents_tags" {
  description = "(Optional) A mapping of tags to assign to the Node Pool."
  type        = map(string)
  default     = {}
}

variable "agents_max_pods" {
  description = "(Optional) The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
  type        = number
  default     = null
}

variable "identity_type" {
  description = "(Optional) The type of identity used for the managed cluster. Conflict with `client_id` and `client_secret`. Possible values are `SystemAssigned` and `UserAssigned`. If `UserAssigned` is set, a `user_assigned_identity_id` must be set as well."
  type        = string
  default     = "SystemAssigned"
}

variable "user_assigned_identity_id" {
  description = "(Optional) The ID of a user assigned identity."
  type        = string
  default     = null
}

variable "enable_host_encryption" {
  description = "Enable Host Encryption for default node pool. Encryption at host feature must be enabled on the subscription: https://docs.microsoft.com/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli"
  type        = bool
  default     = false
}

variable "worker_orchestrator_version" {
  description = "Worker agent pool - Specify which Kubernetes release to use for the orchestration layer. The default used is the latest Kubernetes version available in the region"
  type        = string
  default     = null
}

variable "worker_agents_pool_name" {
  description = "The AKS worker agentpool (nodepool) name."
  type        = string
  default     = "workerpool"
}

variable "worker_agents_size" {
  default     = "Standard_D2s_v3"
  description = "The worker agent pool virtual machine size for the Kubernetes agents"
  type        = string
}

variable "worker_os_disk_size_gb" {
  description = "Disk size of nodes in GBs."
  type        = number
  default     = 200
}

variable "worker_vnet_subnet_id" {
  description = "(Optional) The ID of a Subnet where the Kubernetes worker Node Pool should exist. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "worker_enable_auto_scaling" {
  description = "Enable worker node pool autoscaling"
  type        = bool
  default     = false
}

variable "worker_agents_max_count" {
  type        = number
  description = "Maximum number of worker nodes in a pool"
  default     = null
}

variable "worker_agents_min_count" {
  type        = number
  description = "Minimum number of worker nodes in a pool"
  default     = null
}

variable "worker_enable_node_public_ip" {
  description = "(Optional) Should nodes in this Node Pool have a Public IP Address? Defaults to false."
  type        = bool
  default     = false
}

variable "worker_agents_availability_zones" {
  description = "(Optional) A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created."
  type        = list(string)
  default     = null
}

variable "worker_agents_labels" {
  description = "(Optional) A map of Kubernetes labels which should be applied to nodes in the Worker Node Pool. Changing this forces a new resource to be created."
  type        = map(string)
  default     = {}
}

variable "worker_agents_max_pods" {
  description = "(Optional) The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
  type        = number
  default     = null
}

variable "worker_enable_host_encryption" {
  description = "Enable Host Encryption for worker node pool. Encryption at host feature must be enabled on the subscription: https://docs.microsoft.com/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli"
  type        = bool
  default     = false
}

variable "worker_agents_tags" {
  description = "(Optional) A mapping of tags to assign to the Worker Node Pool."
  type        = map(string)
  default     = {}
}

variable "prometheus_worker_orchestrator_version" {
  description = "Prometheus Worker agent pool - Specify which Kubernetes release to use for the orchestration layer. The default used is the latest Kubernetes version available in the region"
  type        = string
  default     = null
}

variable "prometheus_worker_agents_pool_name" {
  description = "The AKS Prometheus worker agentpool (nodepool) name."
  type        = string
  default     = "prometheus"
}

variable "prometheus_worker_agents_size" {
  default     = "Standard_D8s_v3"
  description = "The worker agent pool virtual machine size for the Kubernetes agents"
  type        = string
}

variable "prometheus_worker_os_disk_size_gb" {
  description = "Disk size of nodes in GBs."
  type        = number
  default     = 200
}

variable "prometheus_worker_vnet_subnet_id" {
  description = "(Optional) The ID of a Subnet where the Kubernetes worker Node Pool should exist. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "prometheus_worker_enable_auto_scaling" {
  description = "Enable worker node pool autoscaling"
  type        = bool
  default     = false
}

variable "prometheus_worker_agents_max_count" {
  type        = number
  description = "Maximum number of worker nodes in a pool"
  default     = null
}

variable "prometheus_worker_agents_min_count" {
  type        = number
  description = "Minimum number of worker nodes in a pool"
  default     = null
}

variable "prometheus_worker_enable_node_public_ip" {
  description = "(Optional) Should nodes in this Node Pool have a Public IP Address? Defaults to false."
  type        = bool
  default     = false
}

variable "prometheus_worker_agents_availability_zones" {
  description = "(Optional) A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created."
  type        = list(string)
  default     = null
}

variable "prometheus_worker_agents_labels" {
  description = "(Optional) A map of Kubernetes labels which should be applied to nodes in the Prometheus Worker Node Pool. Changing this forces a new resource to be created."
  type        = map(string)
  default = {
    "nodepool" : "prometheus_worker_node"
  }
}

variable "prometheus_worker_node_taints" {
  description = "(Optional) A map of Kubernetes taints which should be applied to nodes in the Prometheus Prometheus Worker Node Pool. Changing this forces a new resource to be created."
  type        = list(string)
  default = [
    "PrometheusOnly=true:NoSchedule"
  ]
}

variable "prometheus_worker_agents_max_pods" {
  description = "(Optional) The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
  type        = number
  default     = null
}

variable "prometheus_worker_enable_host_encryption" {
  description = "Enable Host Encryption for worker node pool. Encryption at host feature must be enabled on the subscription: https://docs.microsoft.com/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli"
  type        = bool
  default     = false
}

variable "prometheus_worker_agents_tags" {
  description = "(Optional) A mapping of tags to assign to the Prometheus Worker Node Pool."
  type        = map(string)
  default = {
    "Agent" : "prometheus_worker_agent"
  }
}

variable "only_critical_addons_enabled" {
  description = "Enabling this option will taint default node pool with CriticalAddonsOnly=true:NoSchedule"
  type        = bool
  default     = false
}

variable "workspace_resource_group_name" {
  type        = string
  description = "resource grpup where workspace is created"
  default     = null
}

variable "private_cluster_public_fqdn_enabled" {
  description = "Specifies whether a Public FQDN for this Private Cluster should be added."
  type        = bool
  default     = true
}
variable "oidc_issuer_enabled" {
  description = "Specifies whether a Public FQDN for this Private Cluster should be added."
  type        = bool
  default     = false
}

variable "workload_identity_enabled" {
  description = "Specifies whether a Public FQDN for this Private Cluster should be added."
  type        = bool
  default     = false
}

variable "secret_rotation_enabled" {
  description = "Specifies whether the Azure Key Vault provider should be enabled."
  type        = bool
  default     = false
}

variable "secret_rotation_interval" {
  description = "The interval to poll for secret rotation."
  type        = string
  default     = null
}

variable "temporary_name_for_rotation" {
  description = "Specifies the name of the temporary node pool used to cycle the default node pool for VM resizing."
  type        = string
  default     = "tmpnodepool"
}
