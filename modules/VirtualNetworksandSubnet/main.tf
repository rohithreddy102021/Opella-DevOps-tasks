locals {
  subnetId = { for item in var.VNet.Subnets : item.Name => item }
}

resource "azurerm_virtual_network" "AZ-UHG-VNET-VN" {
  for_each            = var.VNet.VNet
  name                = "${each.value.Name}-${each.value.AzureRegion}"
  location            = var.location
  resource_group_name = var.resourcegroups[each.value.RGKey].name
  address_space       = each.value.AddressSpace
  tags                = var.tags
}

resource "azurerm_subnet" "AZ-UHG-VNET-Subnet" {
  for_each             = local.subnetId
  name                 = each.key == "AzureBastionSubnet" ? "${each.key}" :"${each.key}-${var.Env}-${each.value.AzureRegion}"
  resource_group_name  = azurerm_virtual_network.AZ-UHG-VNET-VN[each.value.VNetKey].resource_group_name
  virtual_network_name = azurerm_virtual_network.AZ-UHG-VNET-VN[each.value.VNetKey].name
  address_prefixes     = [each.value.AddressPrefix]
  service_endpoints    = each.value.ServiceEndpoints
  private_endpoint_network_policies  = each.value.private_endpoint_network_policies 
  dynamic "delegation" {
    for_each = each.value.Delegation == null ? [] : tolist([each.value.Delegation])
    content {
      name = "${each.key}-${var.Env}-DG"
      service_delegation {
        name = delegation.value
      }
    }
  }
  lifecycle {
    ignore_changes = [
      delegation
    ]
  }
}
