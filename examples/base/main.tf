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
