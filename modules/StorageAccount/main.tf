locals {
  subnetList = {
    for key, value in var.StorageAccount : key => {
      subnet_ids = [
        for item in value.NetworkRule.SubnetKeyList : var.Subnet[item].id
      ]
    }
  }
  containerList = flatten([
    for key, value in var.StorageAccount : [
      for item in value.Containers : {
        "Key"           = key,
        "ContainerName" = item
      }
    ]
  ])
  containerMap = {
    for item in local.containerList : "${item.Key}-${item.ContainerName}" => item
  }
  ShareList = flatten([
    for key, value in var.StorageAccount : [
      for item in value.FileShare : {
        "Key"           = key,
        "FileShareName" = item.name 
        "quota"         = item.quota
      }
    ]
  ])
  ShareMap = {
    for item in local.ShareList : "${item.Key}-${item.FileShareName}" => item
  }
}


resource "azurerm_storage_account" "AZ-UHG-SA" {
  for_each            = var.StorageAccount
  name                = "${each.value.Name}${var.Env}${each.value.AzureRegion}"
  resource_group_name = var.resourcegroups[each.value.RGKey].name

  location                  = var.location
  account_tier              = each.value.AccountTier
  account_replication_type  = each.value.AccountReplicationType
  account_kind              = each.value.accountkind
  https_traffic_only_enabled  = true
  allow_nested_items_to_be_public        = false
  min_tls_version                = "TLS1_2"
  cross_tenant_replication_enabled = false

  access_tier  = each.value.access_tier 

  is_hns_enabled = each.value.DataLake

  network_rules {
    default_action             = each.value.NetworkRule.AllNetwork
    virtual_network_subnet_ids = local.subnetList[each.key].subnet_ids
  }
  tags = var.tags
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_container" "AZ-UHG-SA-Cont" {
  for_each              = local.containerMap
  name                  = each.value.ContainerName
  storage_account_id  = azurerm_storage_account.AZ-UHG-SA[each.value.Key].id
  container_access_type = "private"
}

resource "azurerm_storage_share" "AZ-UHG-SA-Share" {
    for_each             = local.ShareMap
    name                 = each.value.FileShareName
    storage_account_id = azurerm_storage_account.AZ-UHG-SA[each.value.Key].id
    quota                = each.value.quota
}
