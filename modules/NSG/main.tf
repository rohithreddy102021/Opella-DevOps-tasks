
locals {
  nsgSubnetLink = compact([for item in var.VNet.Subnets : item.NSGSubnetKey == "" ? "" : "{\"subnetkey\":\"${item.Name}\",\"nsgkey\":\"${item.NSGSubnetKey}\"}"])
  nsgLinkList = {
    for item in local.nsgSubnetLink : jsondecode(item).subnetkey => jsondecode(item).nsgkey
  }
} 
  resource "azurerm_network_security_group" "AZ-UHG-NSG" {
  for_each            = var.NSG.NSG
  name                = "${each.key}-${var.Env}-nsg-${each.value.AzureRegion}"
  location            = var.location
  resource_group_name = var.resourcegroups[each.value.RGKey].name
  lifecycle {
    ignore_changes = [
      security_rule,
      tags
    ]
  }
  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "AZ-UHG-VNET-Subnet-NSG" {
  for_each                  = local.nsgLinkList
  subnet_id                 = var.Subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.AZ-UHG-NSG[each.value].id
  lifecycle {
    ignore_changes = [
      subnet_id,
      network_security_group_id
    ]
  }
}

##NSG Rule Set1 
resource "azurerm_network_security_rule" "AZ-UHG-NSG-Rule" {
  for_each                    = var.NSG.NSGRules
  name                        = each.key
  priority                    = each.value.priority
  direction                   = each.value.Direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.resourcegroups[each.value.RGKey].name
  network_security_group_name = azurerm_network_security_group.AZ-UHG-NSG[each.value.NSGSubnetKey].name

  depends_on = [
    azurerm_network_security_group.AZ-UHG-NSG
  ]
}