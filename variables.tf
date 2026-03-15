variable "name" {
  description = "The name of the MySQL Flexible Server. Must be globally unique, 3–63 characters, lowercase alphanumeric and hyphens only."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", var.name))
    error_message = try(local.metadata.validator_error_messages["name"], "Server name must be 3–63 characters, start and end with a lowercase letter or digit, and contain only lowercase letters, digits, and hyphens.")
  }
}

variable "resource_group_name" {
  description = "The name of the Resource Group where the MySQL Flexible Server will be created."
  type        = string
}

variable "administrator_login" {
  description = "The administrator login name for the MySQL Flexible Server. Required when create_mode is Default."
  type        = string
  default     = null
}

variable "administrator_password" {
  description = "The administrator password for the MySQL Flexible Server. WARNING: This value is stored in Terraform state in plaintext. Ensure your state backend is encrypted at rest and access-controlled."
  type        = string
  default     = null
  sensitive   = true
}

variable "sku_name" {
  description = "The SKU Name for the MySQL Flexible Server (e.g. B_Standard_B1ms, GP_Standard_D2ds_v4, MO_Standard_E4ds_v4)."
  type        = string
  default     = null

  validation {
    condition     = var.sku_name == null || can(regex("^(B_Standard_B|GP_Standard_D|MO_Standard_E)", var.sku_name))
    error_message = try(local.metadata.validator_error_messages["sku_name"], "SKU name must start with B_Standard_B, GP_Standard_D, or MO_Standard_E.")
  }
}

variable "mysql_version" {
  description = "The version of MySQL to use. Possible values are 5.7 and 8.0.21."
  type        = string
  default     = null

  validation {
    condition     = var.mysql_version == null || contains(["5.7", "8.0.21"], var.mysql_version)
    error_message = try(local.metadata.validator_error_messages["mysql_version"], "MySQL version must be one of: 5.7, 8.0.21.")
  }
}

variable "zone" {
  description = "The Availability Zone in which the MySQL Flexible Server should be located."
  type        = string
  default     = null
}

variable "delegated_subnet_id" {
  description = "The ID of the virtual network subnet for VNet integration. Requires private_dns_zone_id."
  type        = string
  default     = null
}

variable "private_dns_zone_id" {
  description = "The ID of the private DNS zone to associate with the MySQL Flexible Server. Required when delegated_subnet_id is set."
  type        = string
  default     = null

  validation {
    condition     = var.delegated_subnet_id == null || var.private_dns_zone_id != null
    error_message = try(local.metadata.validator_error_messages["private_dns_zone_id"], "private_dns_zone_id is required when delegated_subnet_id is set.")
  }
}

variable "backup_retention_days" {
  description = "The backup retention period in days. Must be between 1 and 35."
  type        = number
  default     = null

  validation {
    condition     = var.backup_retention_days == null || (var.backup_retention_days >= 1 && var.backup_retention_days <= 35)
    error_message = try(local.metadata.validator_error_messages["backup_retention_days"], "backup_retention_days must be between 1 and 35.")
  }
}

variable "geo_redundant_backup_enabled" {
  description = "Whether geo-redundant backups are enabled for the MySQL Flexible Server."
  type        = bool
  default     = null
}

variable "storage" {
  description = "Storage configuration for the MySQL Flexible Server."
  type = object({
    auto_grow_enabled = optional(bool, null)
    iops              = optional(number, null)
    size_gb           = optional(number, null)
  })
  default = null
}

variable "high_availability" {
  description = "High availability configuration for the MySQL Flexible Server."
  type = object({
    mode                      = string
    standby_availability_zone = optional(string, null)
  })
  default = null

  validation {
    condition     = var.high_availability == null || contains(["SameZone", "ZoneRedundant"], var.high_availability.mode)
    error_message = try(local.metadata.validator_error_messages["high_availability_mode"], "high_availability.mode must be one of: SameZone, ZoneRedundant.")
  }
}

variable "maintenance_window" {
  description = "Maintenance window configuration for the MySQL Flexible Server."
  type = object({
    day_of_week  = optional(number, null)
    start_hour   = optional(number, null)
    start_minute = optional(number, null)
  })
  default = null
}

variable "databases" {
  description = "A map of MySQL databases to create on this server. The map key is used as the database name."
  type = map(object({
    charset   = string
    collation = string
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to assign to the MySQL Flexible Server. Merged with tags from var.metadata."
  type        = map(string)
  default     = {}
}

variable "require_secure_transport" {
  description = "Whether to require TLS for all client connections. Defaults to ON (secure by default). Set to OFF only when explicitly required."
  type        = string
  default     = "ON"

  validation {
    condition     = contains(["ON", "OFF"], var.require_secure_transport)
    error_message = try(local.metadata.validator_error_messages["require_secure_transport"], "require_secure_transport must be ON or OFF.")
  }
}
