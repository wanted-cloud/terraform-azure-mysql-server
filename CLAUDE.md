# terraform-azure-mysql-server

Terraform building block module wrapping `azurerm_mysql_flexible_server` and `azurerm_mysql_flexible_database` resources, following the wanted-cloud module skeleton pattern.

## Tech Stack

- **Language**: HCL (Terraform)
- **Provider**: hashicorp/azurerm >= 4.20.0
- **Terraform**: >= 1.11
- **Docs**: terraform-docs (injected into README.md)

## Architecture

This is a single-responsibility building block module. It provisions one Azure MySQL Flexible Server (`azurerm_mysql_flexible_server`) and zero-or-more databases (`azurerm_mysql_flexible_database`) on top of it. Supporting resources (e.g. private DNS zone, subnet delegation) are out of scope for this module and are expected to be wired in by the caller.

### Resource hierarchy

```
azurerm_mysql_flexible_server "this"        ← primary resource
  └── azurerm_mysql_flexible_database "this"  ← one per var.databases entry
data.azurerm_resource_group "this"          ← RG lookup (name + location)
```

### Module structure (wanted-cloud skeleton)

```
terraform-azure-mysql-server/
├── main.tf          # Primary resources: server + databases
├── variables.tf     # All input variable declarations
├── outputs.tf       # Module outputs (full resource objects)
├── versions.tf      # terraform + provider version constraints
├── locals.tf        # Module-level local definitions (default tags, etc.)
├── metadata.tf      # ⚠ DO NOT MODIFY — shared metadata construct
│                    #   Exposes: local.metadata.resource_timeouts
│                    #            local.metadata.tags
│                    #            local.metadata.validator_error_messages
│                    #            local.metadata.validator_expressions
├── .terraform-docs.yaml
├── Makefile
├── README.md        # Auto-generated via terraform-docs
└── examples/
    └── base/
        └── main.tf  # Minimal usage example (embedded in README)
```

## Conventions

### Naming

- Primary resource of each type is always named `"this"`.
- Multiple instances (e.g. databases) use `for_each` over a map variable.
- Data sources follow the same `"this"` convention: `data.azurerm_resource_group.this`.

### Variables

- `name`, `resource_group_name` are always required strings.
- `location` is read from the data source — not a separate variable.
- Tags are passed via `var.metadata.tags` (merged in `metadata.tf`) or a top-level `tags` variable.
- Optional complex arguments use `optional()` typed objects with sensible defaults.
- Validation uses `local.metadata.validator_expressions` and `local.metadata.validator_error_messages` so callers can override messages.

### Timeouts

Always wire timeouts from `local.metadata.resource_timeouts`:

```hcl
timeouts {
  create = try(local.metadata.resource_timeouts["azurerm_mysql_flexible_server"]["create"],
               local.metadata.resource_timeouts["default"]["create"])
  read   = try(local.metadata.resource_timeouts["azurerm_mysql_flexible_server"]["read"],
               local.metadata.resource_timeouts["default"]["read"])
  update = try(local.metadata.resource_timeouts["azurerm_mysql_flexible_server"]["update"],
               local.metadata.resource_timeouts["default"]["update"])
  delete = try(local.metadata.resource_timeouts["azurerm_mysql_flexible_server"]["delete"],
               local.metadata.resource_timeouts["default"]["delete"])
}
```

### Dynamic blocks

Use `dynamic` blocks for all optional nested configurations (e.g. `high_availability`, `maintenance_window`, `storage`, `backup`).

### Outputs

Export full resource objects so callers can access any attribute without the module needing updates:

```hcl
output "mysql_flexible_server" {
  value = azurerm_mysql_flexible_server.this
}
```

### Git / commits

Follow Conventional Commits 1.0.0. Use the `/version-control` skill for commits and releases.

## Target Resources

### `azurerm_mysql_flexible_server`

Key arguments to expose as variables:

| Argument | Required | Notes |
|---|---|---|
| `name` | yes | |
| `resource_group_name` | yes | Used for data source lookup |
| `administrator_login` | no | Required unless `create_mode = Replica` |
| `administrator_password` | no | Sensitive |
| `sku_name` | no | e.g. `B_Standard_B1ms` |
| `version` | no | `5.7` or `8.0.21` |
| `zone` | no | Availability zone |
| `create_mode` | no | `Default`, `PointInTimeRestore`, `GeoRestore`, `Replica` |
| `delegated_subnet_id` | no | For VNet integration |
| `private_dns_zone_id` | no | Required with `delegated_subnet_id` |
| `backup_retention_days` | no | 1–35 |
| `geo_redundant_backup_enabled` | no | bool |
| `high_availability` | no | dynamic block: `mode`, `standby_availability_zone` |
| `maintenance_window` | no | dynamic block: `day_of_week`, `start_hour`, `start_minute` |
| `storage` | no | dynamic block: `auto_grow_enabled`, `iops`, `size_gb` |
| `tags` | no | Merged with `local.metadata.tags` |

### `azurerm_mysql_flexible_database`

| Argument | Required | Notes |
|---|---|---|
| `name` | yes | MySQL identifier |
| `server_name` | yes | References `azurerm_mysql_flexible_server.this.name` |
| `resource_group_name` | yes | Same as server |
| `charset` | yes | e.g. `utf8mb4` |
| `collation` | yes | e.g. `utf8mb4_unicode_ci` |

Expose as `var.databases = map(object({ charset, collation }))` with `for_each`.

## Development

### Prerequisites

- Terraform >= 1.11
- terraform-docs (for `make docs`)
- Azure subscription + `az login` or service principal env vars

### Commands

| Command | Purpose |
|---------|---------|
| `make format` | Run `terraform fmt` |
| `make docs` | Regenerate README.md via terraform-docs |
| `make valid` | Run `terraform validate` |
| `make plan` | Run `terraform plan` |
| `make apply` | Run `terraform apply` |
| `make package` | Format + docs (pre-publish) |

## MRLM Plugin Usage

This project uses the [mrlm devstack plugin](https://github.com/mrlm-net/devstack) for AI-assisted development. Available commands:

| Command | What it does |
|---------|-------------|
| `/spec` | Gather requirements, write user stories and acceptance criteria |
| `/design` | Design system architecture, define interfaces and technical patterns |
| `/build` | Implement code and unit tests (engineer only, no review) |
| `/review` | Systematic code review for correctness, style, and performance |
| `/test` | Run E2E, performance, UX, and accessibility testing |
| `/secure` | Vulnerability scan, SBOM generation, OWASP compliance check |
| `/deploy` | Infrastructure provisioning and deployment automation |
| `/make` | Full SDLC pipeline — from requirements through security scan |
| `/ask` | Ask any question using full agent toolkit (read-only) |
| `/write` | Generate articles, documentation, or marketing content |
| `/release` | Publish versioned release with changelog, git tag, and GitHub Release |
| `/scope` | Plan from issue/work item or topic — analysis, design, planning, and backlog creation |
| `/init` | Initialize project structure and CLAUDE.md |

### Recommended Workflow

For implementing the module resources: `/build implement azurerm_mysql_flexible_server and azurerm_mysql_flexible_database following wanted-cloud conventions`

For a full pipeline: `/make [feature description]`
