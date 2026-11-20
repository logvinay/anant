output "github_variables" {
  description = "Set these as GitHub repository variables (Settings > Secrets and variables > Actions > Variables)"
  value = {
    AZURE_CLIENT_ID       = azurerm_user_assigned_identity.github.client_id
    AZURE_TENANT_ID       = data.azurerm_client_config.current.tenant_id
    AZURE_SUBSCRIPTION_ID = data.azurerm_client_config.current.subscription_id
  }
}

output "app_resource_group" {
  value = azurerm_resource_group.app.name
}

output "state_storage_account" {
  value = azurerm_storage_account.tfstate.name
}
