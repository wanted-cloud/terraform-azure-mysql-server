/*
 * # mrlm-net/terraform-azure-mysql-server
 *
 * Terraform building block module wrapping azurerm_mysql_flexible_server
 * and azurerm_mysql_flexible_database resources.
 */

terraform {
  required_version = ">= 1.11"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.20.0, < 5.0.0"
    }
  }
}
