variable "name" {
  description = "Instance pool name."
  type        = string
  nullable    = false

  validation {
    condition     = try(length(trimspace(var.name)) > 0, false)
    error_message = "name must not be empty or blank."
  }
}

variable "node_type_id" {
  description = "Azure VM size for the pool, for example Standard_DS3_v2."
  type        = string
  nullable    = false

  validation {
    condition     = try(length(trimspace(var.node_type_id)) > 0, false)
    error_message = "node_type_id must not be empty or blank."
  }
}

variable "min_idle_instances" {
  description = "Instances the pool keeps ready."
  type        = number
  nullable    = false

  validation {
    condition     = try(var.min_idle_instances >= 0 && floor(var.min_idle_instances) == var.min_idle_instances, false)
    error_message = "min_idle_instances must be an integer of at least 0."
  }
}

variable "idle_instance_autotermination_minutes" {
  description = "Minutes an idle instance stays in the pool above min_idle_instances."
  type        = number
  nullable    = false

  validation {
    condition     = try(var.idle_instance_autotermination_minutes >= 0 && floor(var.idle_instance_autotermination_minutes) == var.idle_instance_autotermination_minutes, false)
    error_message = "idle_instance_autotermination_minutes must be an integer of at least 0."
  }
}

variable "enable_elastic_disk" {
  description = "Add disk space to pool instances when they run low."
  type        = bool
  nullable    = false
}

variable "preloaded_spark_versions" {
  description = "Databricks Runtime versions cached on pool instances."
  type        = list(string)
}

variable "max_capacity" {
  description = "Maximum number of instances in the pool."
  type        = number
  default     = null
  validation {
    condition     = var.max_capacity == null ? true : try(var.max_capacity >= 1 && floor(var.max_capacity) == var.max_capacity, false)
    error_message = "max_capacity must be null or an integer of at least 1."
  }
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

  default  = []
  nullable = false

  validation {
    condition = try(alltrue([for permission in var.permissions :
      length([for principal in [permission.group_name, permission.user_name, permission.service_principal_name] :
        principal if principal != null
      ]) == 1 &&
      alltrue([for principal in [permission.group_name, permission.user_name, permission.service_principal_name] :
        principal == null ? true : length(trimspace(principal)) > 0
      ]) && contains(["CAN_ATTACH_TO", "CAN_MANAGE"], permission.permission_level)
    ]), false)
    error_message = "Each permission needs exactly one nonblank principal and a supported level: CAN_ATTACH_TO, CAN_MANAGE."
  }
}
