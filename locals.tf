locals {
  resource_group_name          = "rg-${var.name}-${var.environment}"
  log_analytics_workspace_name = "log-${var.name}-${var.environment}"

  tags = merge(var.tags, {
    project     = var.name
    environment = var.environment
    managed_by  = "terraform"
  })
}
