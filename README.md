# Databricks instance pool Terraform module

One instance pool.

Creates one instance pool and, when `permissions` is not empty, one `databricks_permissions` block on it.

## Resources

- `databricks_instance_pool.this`
- `databricks_permissions.this[0]` (count = 1 only when `permissions` is not empty)

The resource addresses above are part of the DataTF import contract. Do not rename them.

## Usage

```hcl
module "instance_pool" {
  source  = "536tech/instance-pool/databricks"
  version = "1.0.1"

  name                                  = "shared-pool"
  node_type_id                          = "Standard_DS3_v2"
  min_idle_instances                    = 1
  max_capacity                          = 10
  idle_instance_autotermination_minutes = 15
  enable_elastic_disk                   = true
  preloaded_spark_versions              = ["15.4.x-scala2.12"]

  azure_attributes = {
    availability       = "ON_DEMAND_AZURE"
    spot_bid_max_price = -1
  }

  permissions = [{
    permission_level = "CAN_MANAGE"
    user_name        = "jon@example.com"
  }]
}
```

## Compatibility

Configure the Databricks provider in the calling root with a workspace endpoint.
This resource module is also used by the
[workspace pattern module](https://registry.terraform.io/modules/536tech/workspace/databricks/latest).
Each repository has its own releases. Consumers select an exact tested module version.

The resource addresses match the original workspace submodule in version 0.1.1.
To migrate a direct submodule call, change its source and version. Keep the module block name.
Run `terraform init` and require a plan with no resource changes.
DataTF exports continue to use the workspace pattern module and its existing import addresses.

## Development

Use Terraform 1.7 or later for the mock tests. The module supports Terraform 1.5 or later.

```sh
prek install
terraform init -backend=false -lockfile=readonly
terraform validate
terraform test
tflint --recursive
prek run --all-files
```

CI tests the committed provider version and the minimum supported provider, 1.128.0.
The workspace pattern module checks the complete DataTF contract and its integration behavior.

## License

[Apache-2.0](LICENSE).

## Input safeguards

The module rejects blank required names and invalid access inputs during the plan.
Cross-input preconditions preserve the Terraform 1.5 minimum and existing resource addresses.
A null or zero `max_capacity` keeps the provider's unlimited-capacity behavior.
Null remains valid for inputs where the provider supplies a default.
Provider and API checks still apply. These checks do not prove complete permission visibility.

Each permission needs exactly one nonblank principal and a supported resource-specific permission level.
`databricks_permissions` manages the object's permission set. Keep one state owner for that set.
Empty permissions omit the permission resource.
See [provider permission semantics](https://github.com/databricks/terraform-provider-databricks/blob/v1.130.0/docs/resources/permissions.md).

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- terraform (>= 1.5.0)

- databricks (>= 1.128.0, < 2.0.0)

## Providers

The following providers are used by this module:

- databricks (>= 1.128.0, < 2.0.0)

## Resources

The following resources are used by this module:

- [databricks_instance_pool.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/instance_pool) (resource)
- [databricks_permissions.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) (resource)

## Required Inputs

The following input variables are required:

### enable\_elastic\_disk

Description: Add disk space to pool instances when they run low.

Type: `bool`

### idle\_instance\_autotermination\_minutes

Description: Minutes an idle instance stays in the pool above min\_idle\_instances.

Type: `number`

### min\_idle\_instances

Description: Instances the pool keeps ready.

Type: `number`

### name

Description: Instance pool name.

Type: `string`

### node\_type\_id

Description: Azure VM size for the pool, for example Standard\_DS3\_v2.

Type: `string`

### preloaded\_spark\_versions

Description: Databricks Runtime versions cached on pool instances.

Type: `list(string)`

## Optional Inputs

The following input variables are optional (have default values):

### azure\_attributes

Description: Azure placement settings for pool instances.

Type:

```hcl
object({
    availability       = optional(string)
    spot_bid_max_price = optional(number)
  })
```

Default: `null`

### custom\_tags

Description: Tags applied to pool instances.

Type: `map(string)`

Default: `null`

### max\_capacity

Description: Maximum number of instances in the pool.

Type: `number`

Default: `null`

### permissions

Description: Direct permissions on the pool. Each element names exactly one principal.

Type:

```hcl
list(object({
    permission_level       = string
    group_name             = optional(string)
    user_name              = optional(string)
    service_principal_name = optional(string)
  }))
```

Default: `[]`

## Outputs

The following outputs are exported:

### id

Description: Instance pool id.

### name

Description: Instance pool name.
<!-- END_TF_DOCS -->
