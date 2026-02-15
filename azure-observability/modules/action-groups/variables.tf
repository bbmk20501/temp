variable "name_prefix" {
  description = "Prefix for action group names"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "email_receivers" {
  description = "List of email notification receivers"
  type = list(object({
    name          = string
    email_address = string
  }))
  default = []
}

variable "webhook_receivers" {
  description = "List of webhook notification receivers"
  type = list(object({
    name        = string
    service_uri = string
  }))
  default = []
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
