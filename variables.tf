
variable "gitops_config" {
  type        = object({
    boostrap = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
    })
    infrastructure = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    services = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    applications = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
  })
  description = "Config information regarding the gitops repo structure"
}

variable "git_credentials" {
  type = list(object({
    repo = string
    url = string
    username = string
    token = string
  }))
  description = "The credentials for the gitops repo(s)"
}

variable "namespace" {
  type        = string
  description = "The namespace where the application should be deployed"
}

variable "server_name" {
  type        = string
  description = "The name of the server"
  default     = "default"
}

variable "banner_background_color" {
  type        = string
  description = "The background color of the top banner. This value can be a named color (e.g. purple, red) or an RGB value (#FF0000)."
  default     = "purple"
}

variable "banner_text_color" {
  type        = string
  description = "The text color for the top banner. This value can be a named color (e.g. purple, red) or an RGB value (#FF0000)."
  default     = "white"
}

variable "banner_text" {
  type        = string
  description = "The text that will appear in the top banner in the cluster"
}
