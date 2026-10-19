mock_provider "azurerm" {}

run "defaults" {
  command = plan

  variables {
    name = "webapp"
  }

  assert {
    condition     = azurerm_resource_group.main.name == "rg-webapp-dev"
    error_message = "Resource group should be rg-webapp-dev."
  }

  assert {
    condition     = azurerm_resource_group.main.location == "uksouth"
    error_message = "Location should default to uksouth."
  }

  assert {
    condition     = azurerm_resource_group.main.tags["managed_by"] == "terraform"
    error_message = "managed_by tag should be terraform."
  }

  assert {
    condition     = azurerm_resource_group.main.tags["project"] == "webapp"
    error_message = "project tag should be webapp."
  }

  assert {
    condition     = azurerm_resource_group.main.tags["environment"] == "dev"
    error_message = "environment tag should be dev."
  }

  assert {
    condition     = output.resource_group_name == "rg-webapp-dev"
    error_message = "resource_group_name output should be rg-webapp-dev."
  }

  assert {
    condition     = output.location == "uksouth"
    error_message = "location output should be uksouth."
  }
}

run "extra_tags_are_merged" {
  command = plan

  variables {
    name = "webapp"
    tags = {
      owner       = "platform"
      environment = "overridden"
    }
  }

  assert {
    condition     = azurerm_resource_group.main.tags["owner"] == "platform"
    error_message = "User tags should be merged in."
  }

  assert {
    condition     = azurerm_resource_group.main.tags["environment"] == "dev"
    error_message = "User tags must not override built-in tags."
  }
}

run "invalid_name_is_rejected" {
  command = plan

  variables {
    name = "Web_App"
  }

  expect_failures = [var.name]
}

run "invalid_environment_is_rejected" {
  command = plan

  variables {
    name        = "webapp"
    environment = "staging"
  }

  expect_failures = [var.environment]
}
