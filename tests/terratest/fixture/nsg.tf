module "nsg_aks_system" {
  source              = "git::https://github.com/hmcts/cpp-module-terraform-azurerm-network-security-group.git?ref=main"
  resource_group_name = azurerm_resource_group.aks.name
  location            = var.location
  security_group_name = "${var.nsg_aks_system.name}-${random_id.prefix.hex}"
  custom_rules = concat(
    [
      {
        name                       = "Allow_all_from_system_subnet"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefixes    = var.subnet_aks_system.address_prefixes
        destination_address_prefix = "*"
        description                = "Allow inbound from worker subnet"
      },
      {
        name                       = "Allow_all_from_worker_subnet"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefixes    = var.subnet_aks_worker.address_prefixes
        destination_address_prefix = "*"
        description                = "Allow inbound from worker subnet"
      },
    ],
    var.nsg_aks_system.custom_rules
  )
  depends_on = [azurerm_resource_group.aks]
  tags       = var.tags
}
module "nsg_aks_worker" {
  source              = "git::https://github.com/hmcts/cpp-module-terraform-azurerm-network-security-group.git?ref=main"
  resource_group_name = azurerm_resource_group.aks.name
  location            = var.location
  security_group_name = "${var.nsg_aks_worker.name}-${random_id.prefix.hex}"
  custom_rules = concat(
    [
      {
        name                       = "Allow_all_from_worker_subnet"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefixes    = var.subnet_aks_worker.address_prefixes
        destination_address_prefix = "*"
        description                = "Allow inbound from system subnet"
      },
      {
        name                       = "Allow_all_from_system_subnet"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefixes    = var.subnet_aks_system.address_prefixes
        destination_address_prefix = "*"
        description                = "Allow inbound from system subnet"
      },
    ],
    var.nsg_aks_worker.custom_rules
  )
  depends_on = [azurerm_resource_group.aks]
  tags       = var.tags
}
