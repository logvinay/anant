locals {
  suffix           = "${var.name}-${var.environment}"
  use_private_ghcr = var.ghcr_pull_token != ""
  app_port         = 8080
}

data "azurerm_resource_group" "app" {
  name = "rg-${local.suffix}"
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-${local.suffix}"
  resource_group_name = data.azurerm_resource_group.app.name
  location            = data.azurerm_resource_group.app.location
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
}

resource "azurerm_container_app_environment" "main" {
  name                       = "cae-${local.suffix}"
  resource_group_name        = data.azurerm_resource_group.app.name
  location                   = data.azurerm_resource_group.app.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
}

resource "azurerm_container_app" "app" {
  name                         = "ca-${local.suffix}"
  resource_group_name          = data.azurerm_resource_group.app.name
  container_app_environment_id = azurerm_container_app_environment.main.id
  revision_mode                = "Single"

  dynamic "secret" {
    for_each = local.use_private_ghcr ? [1] : []
    content {
      name  = "ghcr-pull-token"
      value = var.ghcr_pull_token
    }
  }

  dynamic "registry" {
    for_each = local.use_private_ghcr ? [1] : []
    content {
      server               = "ghcr.io"
      username             = var.ghcr_username
      password_secret_name = "ghcr-pull-token"
    }
  }

  ingress {
    external_enabled = true
    target_port      = local.app_port

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = var.name
      image  = var.container_image
      cpu    = var.cpu
      memory = var.memory

      liveness_probe {
        transport = "HTTP"
        port      = local.app_port
        path      = "/healthz"
      }

      readiness_probe {
        transport = "HTTP"
        port      = local.app_port
        path      = "/healthz"
      }
    }
  }
}
