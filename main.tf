/*
 * # mrlm-net/terraform-azure-mysql-server
 *
 * Terraform building block module wrapping azurerm_mysql_flexible_server
 * and azurerm_mysql_flexible_database resources.
 */

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_mysql_flexible_server" "this" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password

  sku_name = var.sku_name
  version  = var.mysql_version
  zone     = var.zone

  delegated_subnet_id = var.delegated_subnet_id
  private_dns_zone_id = var.private_dns_zone_id

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  tags = merge(local.metadata.tags, var.tags)

  dynamic "storage" {
    for_each = var.storage != null ? [var.storage] : []
    content {
      auto_grow_enabled = storage.value.auto_grow_enabled
      iops              = storage.value.iops
      size_gb           = storage.value.size_gb
    }
  }

  dynamic "high_availability" {
    for_each = var.high_availability != null ? [var.high_availability] : []
    content {
      mode                      = high_availability.value.mode
      standby_availability_zone = high_availability.value.standby_availability_zone
    }
  }

  dynamic "maintenance_window" {
    for_each = var.maintenance_window != null ? [var.maintenance_window] : []
    content {
      day_of_week  = maintenance_window.value.day_of_week
      start_hour   = maintenance_window.value.start_hour
      start_minute = maintenance_window.value.start_minute
    }
  }

  timeouts {
    create = try(
      local.metadata.resource_timeouts["azurerm_mysql_flexible_server"]["create"],
      local.metadata.resource_timeouts["default"]["create"]
    )
    read = try(
      local.metadata.resource_timeouts["azurerm_mysql_flexible_server"]["read"],
      local.metadata.resource_timeouts["default"]["read"]
    )
    update = try(
      local.metadata.resource_timeouts["azurerm_mysql_flexible_server"]["update"],
      local.metadata.resource_timeouts["default"]["update"]
    )
    delete = try(
      local.metadata.resource_timeouts["azurerm_mysql_flexible_server"]["delete"],
      local.metadata.resource_timeouts["default"]["delete"]
    )
  }
}

resource "azurerm_mysql_flexible_server_configuration" "require_secure_transport" {
  name                = "require_secure_transport"
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = azurerm_mysql_flexible_server.this.name
  value               = var.require_secure_transport
}

resource "azurerm_mysql_flexible_database" "this" {
  for_each = var.databases

  name                = each.key
  server_name         = azurerm_mysql_flexible_server.this.name
  resource_group_name = data.azurerm_resource_group.this.name
  charset             = each.value.charset
  collation           = each.value.collation

  timeouts {
    create = try(
      local.metadata.resource_timeouts["azurerm_mysql_flexible_database"]["create"],
      local.metadata.resource_timeouts["default"]["create"]
    )
    read = try(
      local.metadata.resource_timeouts["azurerm_mysql_flexible_database"]["read"],
      local.metadata.resource_timeouts["default"]["read"]
    )
    delete = try(
      local.metadata.resource_timeouts["azurerm_mysql_flexible_database"]["delete"],
      local.metadata.resource_timeouts["default"]["delete"]
    )
  }
}
