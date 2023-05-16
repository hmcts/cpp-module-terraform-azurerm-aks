module "route_table_egress" {
  source                 = "git::https://github.com/hmcts/cpp-module-terraform-azurerm-routetable.git?ref=main"
  resource_group_name    = azurerm_resource_group.aks.name
  route_table_name       = "${var.route_table_egress.name}-${random_id.prefix.hex}"
  location               = var.location
  route_prefixes         = var.route_table_egress.route_prefixes
  route_nexthop_types    = ["VirtualAppliance"]
  next_hop_in_ip_address = var.route_table_egress.next_hop_in_ip_address
  route_names            = ["GATEWAY-ROUTE"]
  tags                   = var.tags
}
module "subnet_aks_system" {
  source                                                = "git::https://github.com/hmcts/cpp-module-terraform-azurerm-subnet.git?ref=main"
  subnet_name                                           = "${var.subnet_aks_system.name}-${random_id.prefix.hex}"
  core_resource_group_name                              = azurerm_resource_group.aks.name
  virtual_network_name                                  = azurerm_virtual_network.test_vn.name
  subnet_address_prefixes                               = var.subnet_aks_system.address_prefixes
  subnet_enforce_private_link_endpoint_network_policies = true
}
module "subnet_aks_worker" {
  source                   = "git::https://github.com/hmcts/cpp-module-terraform-azurerm-subnet.git?ref=main"
  subnet_name              = "${var.subnet_aks_worker.name}-${random_id.prefix.hex}"
  core_resource_group_name = azurerm_resource_group.aks.name
  virtual_network_name     = azurerm_virtual_network.test_vn.name
  subnet_address_prefixes  = var.subnet_aks_worker.address_prefixes
  service_endpoints        = var.service_endpoints_for_worker
}
resource "azurerm_subnet_network_security_group_association" "nsg_association_aks_system" {
  subnet_id                 = module.subnet_aks_system.id
  network_security_group_id = module.nsg_aks_system.network_security_group_id
}
resource "azurerm_subnet_network_security_group_association" "nsg_association_aks_worker" {
  subnet_id                 = module.subnet_aks_worker.id
  network_security_group_id = module.nsg_aks_worker.network_security_group_id
}
