variable "name" {
  description = "Instance pool name."
  type        = string
}

variable "node_type_id" {
  description = "Azure VM size for the pool, for example Standard_DS3_v2."
  type        = string
}

variable "min_idle_instances" {
  description = "Instances the pool keeps ready."
  type        = number
}

variable "idle_instance_autotermination_minutes" {
  description = "Minutes an idle instance stays in the pool above min_idle_instances."
  type        = number
}

variable "enable_elastic_disk" {
  description = "Add disk space to pool instances when they run low."
  type        = bool
}

variable "preloaded_spark_versions" {
  description = "Databricks Runtime versions cached on pool instances."
  type        = list(string)
}

variable "max_capacity" {
  description = "Maximum number of instances in the pool."
  type        = number
  default     = null
}

variable "custom_tags" {
  description = "Tags applied to pool instances."
  type        = map(string)
  default     = null
}

variable "azure_attributes" {
  description = "Azure placement settings for pool instances."

  type = object({
    availability       = optional(string)
    spot_bid_max_price = optional(number)
  })

  default = null
}

variable "permissions" {
  description = "Direct permissions on the pool. Each element names exactly one principal."

  type = list(object({
    permission_level       = string
    group_name             = optional(string)
    user_name              = optional(string)
    service_principal_name = optional(string)
  }))

  default = []
}
