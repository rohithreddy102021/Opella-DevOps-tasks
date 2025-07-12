output "NSG" {
    value = azurerm_network_security_group.AZ-UHG-NSG
}

output "NSGRules1"{
    value = azurerm_network_security_rule.AZ-UHG-NSG-Rule
}