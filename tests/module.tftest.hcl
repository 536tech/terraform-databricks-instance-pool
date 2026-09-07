mock_provider "databricks" {}

variables {

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

run "documented_example" {
  command = apply

  assert {
    condition     = databricks_instance_pool.this.instance_pool_name == var.name
    error_message = "The resource must preserve its configured name."
  }

  assert {
    condition     = length(databricks_permissions.this) == 1
    error_message = "Configured access must have stable resource addresses."
  }
}

run "without_access" {
  command = plan

  variables {
    permissions = []
  }

  assert {
    condition     = length(databricks_permissions.this) == 0
    error_message = "Empty access must omit the access resources."
  }
}
