variable "name" {
  type        = string
  description = "Base name of the app, used in resource names. 3 to 20 lowercase letters and digits."

  validation {
    condition     = can(regex("^[a-z0-9]{3,20}$", var.name))
    error_message = "name must be 3 to 20 lowercase letters and digits."
  }
}

variable "environment" {
  type        = string
  description = "Deployment environment: dev, test or prod."
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be one of dev, test or prod."
  }
}

variable "location" {
  type        = string
  description = "Azure region to deploy into."
  default     = "uksouth"
}

variable "tags" {
  type        = map(string)
  description = "Extra tags to apply to every taggable resource."
  default     = {}
}
