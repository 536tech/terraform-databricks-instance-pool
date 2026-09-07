output "id" {
  description = "Instance pool id."
  value       = databricks_instance_pool.this.id
}

output "name" {
  description = "Instance pool name."
  value       = databricks_instance_pool.this.instance_pool_name
}
