variable "name" {
  type    = string
  default = "myapp"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "location" {
  type = string
}

variable "github_repository" {
  type        = string
  description = "GitHub repository in owner/repo form, allowed to deploy via OIDC"

  validation {
    condition     = can(regex("^[^/]+/[^/]+$", var.github_repository))
    error_message = "Use the form owner/repo."
  }
}

variable "github_branch" {
  type    = string
  default = "main"
}
