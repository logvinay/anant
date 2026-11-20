variable "name" {
  type = string
}

variable "environment" {
  type = string
}

variable "container_image" {
  type        = string
  description = "Full image reference, e.g. ghcr.io/owner/myapp:<git-sha>"
}

variable "ghcr_username" {
  type        = string
  default     = ""
  description = "GitHub user that owns ghcr_pull_token; leave empty when the GHCR package is public"
}

variable "ghcr_pull_token" {
  type        = string
  default     = ""
  sensitive   = true
  description = "GitHub classic PAT with read:packages; leave empty when the GHCR package is public"
}

variable "cpu" {
  type    = number
  default = 0.25
}

variable "memory" {
  type    = string
  default = "0.5Gi"
}

variable "min_replicas" {
  type    = number
  default = 0
}

variable "max_replicas" {
  type    = number
  default = 2
}

variable "log_retention_days" {
  type    = number
  default = 30
}
