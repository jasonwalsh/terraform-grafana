terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "~> 1.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }

  required_version = "~> 1.0"
}

provider "grafana" {
  auth = "admin:admin"
  url  = local.grafana_url
}

provider "helm" {
  kubernetes {
    config_context = "minikube"
    config_path    = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_context = "minikube"
  config_path    = "~/.kube/config"
}

locals {
  grafana_url = format(
    "http://192.168.64.2:%s",
    data.kubernetes_service.this.spec[0].port[0].node_port
  )
}

data "kubernetes_service" "this" {
  metadata {
    name      = helm_release.this.name
    namespace = helm_release.this.namespace
  }
}

resource "kubernetes_secret" "this" {
  data = {
    "admin-password" = "admin"
    "admin-user"     = "admin"
  }

  metadata {
    name      = "grafana"
    namespace = var.namespace
  }

  type = "Opaque"
}

resource "helm_release" "this" {
  chart        = "grafana"
  force_update = true
  lint         = true
  name         = "grafana"
  namespace    = var.namespace
  repository   = "https://grafana.github.io/helm-charts"

  set {
    name  = "admin.existingSecret"
    value = kubernetes_secret.this.metadata[0].name
  }

  set {
    name  = "image.tag"
    value = var.grafana_version
  }

  set {
    name  = "ingress.enabled"
    value = true
  }

  set {
    name  = "service.type"
    value = "NodePort"
  }

  wait = true
}

resource "grafana_organization" "this" {
  name = "Acme"
}
