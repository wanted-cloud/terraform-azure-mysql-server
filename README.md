<!-- BEGIN_TF_DOCS -->
# mrlm-net/terraform-azure-mysql-server

Terraform building block module wrapping azurerm\_mysql\_flexible\_server
and azurerm\_mysql\_flexible\_database resources.

## Table of contents

- [Requirements](#requirements)
- [Providers](#providers)
- [Variables](#inputs)
- [Outputs](#outputs)
- [Resources](#resources)
- [Usage](#usage)
- [Contributing](#contributing)

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.11)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 4.20.0, < 5.0.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (4.64.0)

## Required Inputs

The following input variables are required:

### <a name="input_name"></a> [name](#input\_name)

Description: The name of the MySQL Flexible Server. Must be globally unique, 3–63 characters, lowercase alphanumeric and hyphens only.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The name of the Resource Group where the MySQL Flexible Server will be created.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_administrator_login"></a> [administrator\_login](#input\_administrator\_login)

Description: The administrator login name for the MySQL Flexible Server. Required when create\_mode is Default.

Type: `string`

Default: `null`

### <a name="input_administrator_password"></a> [administrator\_password](#input\_administrator\_password)

Description: The administrator password for the MySQL Flexible Server. WARNING: This value is stored in Terraform state in plaintext. Ensure your state backend is encrypted at rest and access-controlled.

Type: `string`

Default: `null`

### <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days)

Description: The backup retention period in days. Must be between 1 and 35.

Type: `number`

Default: `null`

### <a name="input_databases"></a> [databases](#input\_databases)

Description: A map of MySQL databases to create on this server. The map key is used as the database name.

Type:

```hcl
map(object({
    charset   = string
    collation = string
  }))
```

Default: `{}`

### <a name="input_delegated_subnet_id"></a> [delegated\_subnet\_id](#input\_delegated\_subnet\_id)

Description: The ID of the virtual network subnet for VNet integration. Requires private\_dns\_zone\_id.

Type: `string`

Default: `null`

### <a name="input_geo_redundant_backup_enabled"></a> [geo\_redundant\_backup\_enabled](#input\_geo\_redundant\_backup\_enabled)

Description: Whether geo-redundant backups are enabled for the MySQL Flexible Server.

Type: `bool`

Default: `null`

### <a name="input_high_availability"></a> [high\_availability](#input\_high\_availability)

Description: High availability configuration for the MySQL Flexible Server.

Type:

```hcl
object({
    mode                      = string
    standby_availability_zone = optional(string, null)
  })
```

Default: `null`

### <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window)

Description: Maintenance window configuration for the MySQL Flexible Server.

Type:

```hcl
object({
    day_of_week  = optional(number, null)
    start_hour   = optional(number, null)
    start_minute = optional(number, null)
  })
```

Default: `null`

### <a name="input_metadata"></a> [metadata](#input\_metadata)

Description: Metadata definitions for the module, this is optional construct allowing override of the module defaults defintions of validation expressions, error messages, resource timeouts and default tags.

Type:

```hcl
object({
    resource_timeouts = optional(
      map(
        object({
          create = optional(string, "30m")
          read   = optional(string, "5m")
          update = optional(string, "30m")
          delete = optional(string, "30m")
        })
      ), {}
    )
    tags                     = optional(map(string), {})
    validator_error_messages = optional(map(string), {})
    validator_expressions    = optional(map(string), {})
  })
```

Default: `{}`

### <a name="input_mysql_version"></a> [mysql\_version](#input\_mysql\_version)

Description: The version of MySQL to use. Possible values are 5.7 and 8.0.21.

Type: `string`

Default: `null`

### <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id)

Description: The ID of the private DNS zone to associate with the MySQL Flexible Server. Required when delegated\_subnet\_id is set.

Type: `string`

Default: `null`

### <a name="input_require_secure_transport"></a> [require\_secure\_transport](#input\_require\_secure\_transport)

Description: Whether to require TLS for all client connections. Defaults to ON (secure by default). Set to OFF only when explicitly required.

Type: `string`

Default: `"ON"`

### <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name)

Description: The SKU Name for the MySQL Flexible Server (e.g. B\_Standard\_B1ms, GP\_Standard\_D2ds\_v4, MO\_Standard\_E4ds\_v4).

Type: `string`

Default: `null`

### <a name="input_storage"></a> [storage](#input\_storage)

Description: Storage configuration for the MySQL Flexible Server.

Type:

```hcl
object({
    auto_grow_enabled = optional(bool, null)
    iops              = optional(number, null)
    size_gb           = optional(number, null)
  })
```

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: A map of tags to assign to the MySQL Flexible Server. Merged with tags from var.metadata.

Type: `map(string)`

Default: `{}`

### <a name="input_zone"></a> [zone](#input\_zone)

Description: The Availability Zone in which the MySQL Flexible Server should be located.

Type: `string`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_mysql_flexible_databases"></a> [mysql\_flexible\_databases](#output\_mysql\_flexible\_databases)

Description: A map of MySQL Flexible Database resource objects, keyed by database name.

### <a name="output_mysql_flexible_server"></a> [mysql\_flexible\_server](#output\_mysql\_flexible\_server)

Description: The MySQL Flexible Server resource object. Marked sensitive because it contains administrator credentials.

## Resources

The following resources are used by this module:

- [azurerm_mysql_flexible_database.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_database) (resource)
- [azurerm_mysql_flexible_server.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server) (resource)
- [azurerm_mysql_flexible_server_configuration.require_secure_transport](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_configuration) (resource)
- [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)

## Usage

> For more detailed examples navigate to `examples` folder of this repository.

Module was also published via Terraform Registry and can be used as a module from the registry.

```hcl
module "example" {
  source  = "mrlm-net/terraform-azure-mysql-server/azurerm"
  version = "~> 1.0"
}
```

### Basic usage example

The minimal usage for the module is as follows:

```hcl
terraform {
  required_version = ">= 1.11"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.20.0, < 5.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "mysql_server" {
  source = "../.."

  name                = "example-mysql-server"
  resource_group_name = "example-resource-group"

  administrator_login    = "mysqladmin"
  administrator_password = "<REPLACE_WITH_STRONG_PASSWORD>"

  sku_name      = "B_Standard_B1ms"
  mysql_version = "8.0.21"

  databases = {
    "application" = {
      charset   = "utf8mb4"
      collation = "utf8mb4_unicode_ci"
    }
  }

  tags = {
    Environment = "development"
  }
}
```
## Contributing

_Contributions are welcomed and must follow [Code of Conduct](https://github.com/mrlm-net/.github?tab=coc-ov-file) and common [Contributions guidelines](https://github.com/mrlm-net/.github/blob/main/docs/CONTRIBUTING.md)._

> If you'd like to report a security issue please follow [security guidelines](https://github.com/mrlm-net/.github?tab=security-ov-file).
---
<sup><sub>_2025 &copy; All rights reserved - mrlm.net_</sub></sup>
<!-- END_TF_DOCS -->