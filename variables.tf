variable "enable" {
  type        = bool
  description = "Enable GuardDuty"
  default     = true
}

variable "finding_publishing_frequency" {
  type        = string
  description = "Finding publishing frequency"
  default     = "SIX_HOURS"
}

variable "datasources" {
  type        = any
  description = "Datasources configuration"
  default     = null
}

variable "publishing_destination" {
  type        = any
  description = "Publishing destination configuration"
  default     = null
}

variable "filter_criteria" {
  type        = list(any)
  description = "Filter criteria list"
  default     = []
}

variable "ipset" {
  type        = any
  description = "IP set configuration"
  default     = null
}

variable "threatintelset" {
  type        = any
  description = "Threat intel set configuration"
  default     = null
}

variable "auto_enable_organization_members" {
  type        = string
  description = "Auto-enable organization members"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
  default     = {}
}
