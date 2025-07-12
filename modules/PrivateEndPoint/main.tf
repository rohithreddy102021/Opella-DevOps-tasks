resource "azurerm_private_endpoint" "AZ-UHG-PrivateEndpoint" {
    for_each                    = var.PrivateEndpoint
    name                        = "${each.value.Name}-${var.Env}-${each.value.AzureRegion}"
    location                    = var.location
    resource_group_name         = var.resourcegroups[each.value.RGKey].name
    subnet_id                   = var.Subnet[each.value.SubnetKey].id
    tags                        = var.tags
  
    private_service_connection {
        name                           = each.value.PSConnectionName
        is_manual_connection           = true
        private_connection_resource_id = each.value.privateconnectionresourceid
        subresource_names              = each.value.privateendpoint_subresource_names
        request_message                = each.value.privateendpoint_request_message
    }
}