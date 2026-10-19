# Conventions for agents working on this repo

A Terraform root module that runs a small web app on Azure Container Apps.
Changes arrive as draft pull requests; a person reviews and applies them.

## Never

- Run `terraform plan` or `apply`, or call Azure. There are no credentials
  here, and there must never be any.
- Hardcode a subscription, tenant or client ID, or add a `backend` block.
  At apply time the provider reads `ARM_SUBSCRIPTION_ID` from the
  environment, and state stays local until a person adds a backend.
- Touch `.factory/`.

## Always

- Terraform `>= 1.9` and `hashicorp/azurerm` `~> 4.0`, pinned in
  `versions.tf`. Keep `.terraform.lock.hcl` committed when it changes.
- Name resources `<abbreviation>-<name>-<environment>` with Azure's
  Cloud Adoption Framework abbreviations (`rg`, `log`, `cae`, `ca`), built
  in `locals.tf`, never inline.
- Tag every taggable resource with `local.tags`: `var.tags` merged with
  `project = var.name`, `environment = var.environment` and
  `managed_by = "terraform"`.
- Give every variable a `description` and a `type`, and a `validation`
  block where bad input is likely. Give every output a `description`.
- Keep resources in files by concern: `main.tf` (resource group),
  `monitoring.tf`, `container_apps.tf`, plus `variables.tf`, `locals.tf`,
  `outputs.tf`, `versions.tf`.
- Come with tests: `tests/*.tftest.hcl` using `mock_provider "azurerm" {}`,
  asserting the values the issue asks for (names, tags, settings), and
  `expect_failures` for variable validation. Run `terraform fmt -recursive`
  before finishing; `.factory/verify.sh` checks fmt, validate and the tests.
