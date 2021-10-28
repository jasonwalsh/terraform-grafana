variable "grafana_version" {
  default     = "latest"
  description = "The Grafana version"
  type        = string
}

variable "namespace" {
  default = "default"
  type    = string
}
