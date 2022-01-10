# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  # This module is now only being tested with Terraform 1.0.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 1.0.x code.
  required_version = ">= 0.12.26"
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY VAULT RESOURCE
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_key_vault" "cardano" {
  name                        = var.vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  sku_name                    = var.sku_name

  network_acls {
    bypass                     = "AzureServices" # required when enabled_for_disk_encryption == true
    default_action             = "Deny"
    virtual_network_subnet_ids = compact(var.allow_subnet_ids)
    ip_rules                   = compact(var.allow_cidrs)
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GRANT ACCESS TO KUBERNETES NODE POOL
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_key_vault_access_policy" "cluster" {
  key_vault_id = azurerm_key_vault.cardano.id
  tenant_id    = var.tenant_id
  object_id    = var.cluster_principal_id

  key_permissions = [
    "Get",
  ]
  secret_permissions = [
    "Get",
  ]
}

resource "azurerm_key_vault_access_policy" "kubelet" {
  key_vault_id = azurerm_key_vault.cardano.id
  tenant_id    = var.tenant_id
  object_id    = var.kubelet_principal_id

  key_permissions = [
    "Get",
  ]
  secret_permissions = [
    "Get",
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL: GRANT ACCESS TO ADMIN USER GROUP WHO WILL BE ABLE TO EDIT VAULT SECRETS
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_key_vault_access_policy" "admins" {
  count        = var.allow_azuread_group ? 1 : 0
  key_vault_id = azurerm_key_vault.cardano.id
  tenant_id    = var.tenant_id
  object_id    = var.azuread_group_principal_id

  key_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
  ]
  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
  ]
}
