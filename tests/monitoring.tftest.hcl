mock_provider "azurerm" {
  mock_resource "azurerm_log_analytics_workspace" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-webapp-dev/providers/Microsoft.OperationalInsights/workspaces/log-webapp-dev"
    }
  }
}

variables {
  name = "webapp"
}

run "workspace_defaults" {
  command = plan

  assert {
    condition     = azurerm_log_analytics_workspace.main.name == "log-webapp-dev"
    error_message = "Workspace should be log-webapp-dev."
  }

  assert {
    condition     = azurerm_log_analytics_workspace.main.resource_group_name == "rg-webapp-dev"
    error_message = "Workspace should be in rg-webapp-dev."
  }

  assert {
    condition     = azurerm_log_analytics_workspace.main.sku == "PerGB2018"
    error_message = "SKU should be PerGB2018."
  }

  assert {
    condition     = azurerm_log_analytics_workspace.main.retention_in_days == 30
    error_message = "Retention should default to 30 days."
  }

  assert {
    condition     = azurerm_log_analytics_workspace.main.tags["project"] == "webapp" && azurerm_log_analytics_workspace.main.tags["environment"] == "dev" && azurerm_log_analytics_workspace.main.tags["managed_by"] == "terraform"
    error_message = "Workspace should carry the standard tags."
  }
}

run "workspace_id_output" {
  command = apply

  assert {
    condition     = output.log_analytics_workspace_id == azurerm_log_analytics_workspace.main.id
    error_message = "Output should be the workspace ID."
  }
}

run "retention_passes_through" {
  command = plan

  variables {
    log_retention_days = 90
  }

  assert {
    condition     = azurerm_log_analytics_workspace.main.retention_in_days == 90
    error_message = "Retention should follow log_retention_days."
  }
}

run "retention_below_minimum_is_rejected" {
  command = plan

  variables {
    log_retention_days = 7
  }

  expect_failures = [var.log_retention_days]
}

run "retention_above_maximum_is_rejected" {
  command = plan

  variables {
    log_retention_days = 731
  }

  expect_failures = [var.log_retention_days]
}
