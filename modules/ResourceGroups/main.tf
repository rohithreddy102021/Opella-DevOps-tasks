resource "azurerm_resource_group" "rg" {
    for_each    = var.resourcegroups
    name        = "${each.value.Name}-${var.Env}-${each.value.AzureRegion}-rg"
    location    = var.location
    tags        = var.tags
  }