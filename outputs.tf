output "mysql_flexible_server" {
  description = "The MySQL Flexible Server resource object. Marked sensitive because it contains administrator credentials."
  value       = azurerm_mysql_flexible_server.this
  sensitive   = true
}

output "mysql_flexible_databases" {
  description = "A map of MySQL Flexible Database resource objects, keyed by database name."
  value       = azurerm_mysql_flexible_database.this
}
