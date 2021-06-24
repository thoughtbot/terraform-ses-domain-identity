variable "authorized_accounts" {
  type        = list(string)
  description = "Other AWS account IDs authorized to use this domain identity"
  default     = []
}

variable "create_records" {
  type        = bool
  description = "Set to false to disable Route 53 record creation"
  default     = true
}

variable "domain" {
  type        = string
  description = "The domain from which emails are sent"
}

variable "namespace" {
  type        = list(string)
  description = "Namespace to prefix resource"
  default     = []
}

variable "tags" {
  description = "Tags which should be applied to created resources"
  default     = {}
  type        = map(string)
}

variable "zone_domain" {
  type        = string
  description = "Name of the AWS Route53; defaults to domain identity"
  default     = null
}
