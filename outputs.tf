output "resource_group_name" {
  description = "Name of the resource group."
  value       = azurerm_resource_group.main.name
}

output "location" {
  description = "Azure region of the resource group."
  value       = azurerm_resource_group.main.location
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.main.id
}
