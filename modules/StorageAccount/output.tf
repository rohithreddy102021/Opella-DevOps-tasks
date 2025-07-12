output "StorageAccount" {
    value = azurerm_storage_account.AZ-UHG-SA
}

output "StorageContainer" {
    value = azurerm_storage_container.AZ-UHG-SA-Cont  
}

output "StorageFileShare"{
    value = azurerm_storage_share.AZ-UHG-SA-Share
}