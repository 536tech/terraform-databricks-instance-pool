resource "databricks_instance_pool" "this" {
  instance_pool_name                    = var.name
  node_type_id                          = var.node_type_id
  min_idle_instances                    = var.min_idle_instances
  idle_instance_autotermination_minutes = var.idle_instance_autotermination_minutes
  enable_elastic_disk                   = var.enable_elastic_disk
  preloaded_spark_versions              = var.preloaded_spark_versions
  max_capacity                          = var.max_capacity
  custom_tags                           = var.custom_tags

  dynamic "azure_attributes" {
    for_each = var.azure_attributes == null ? [] : [var.azure_attributes]

    content {
      availability       = azure_attributes.value.availability
      spot_bid_max_price = azure_attributes.value.spot_bid_max_price
    }
  }
}

resource "databricks_permissions" "this" {
  count = length(var.permissions) > 0 ? 1 : 0

  instance_pool_id = databricks_instance_pool.this.id

  dynamic "access_control" {
    for_each = var.permissions

    content {
      permission_level       = access_control.value.permission_level
      group_name             = access_control.value.group_name
      user_name              = access_control.value.user_name
      service_principal_name = access_control.value.service_principal_name
    }
  }
}
