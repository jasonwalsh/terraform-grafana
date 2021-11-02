## Purpose

This repository contains Terraform configurations for installing the `Grafana` Helm chart in a Kubernetes cluster and using the [`Grafana`](https://registry.terraform.io/providers/grafana/grafana/latest/docs) Terraform provider to create resources such as groups, dashboards, and more.

## Prerequisites

This repository assumes you have access to the following:

- A Kubernetes cluster (>= v1.20)
- Terraform installed (>= v1.0)
- An ingress controller such as [NGINX Ingress Controller](https://docs.nginx.com/nginx-ingress-controller/)

## Quick Start

The quick start uses [minikube](https://minikube.sigs.k8s.io/docs/). If you do not have minikube installed, please download it from their [releases](https://github.com/kubernetes/minikube/releases) page.

**Note:** This quick start guide uses minikube version: v1.18.1. You can download this version [here](https://github.com/kubernetes/minikube/releases/v1.18.1).

**Disclaimer:** I have not tested this repository against other versions of minikube.

After installing minikube, you need to [set up an ingress](https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/). To install the NGINX Ingress Controller, run the following command:

```bash
minikube addons enable ingress
```

After the ingress controller is installed, you can then run the following Terraform commands:

```bash
terraform init
terraform apply
```

The plan will create the following resources:

```
grafana_organization.this
helm_release.this
kubernetes_secret.this
```

The Kubernetes secret contains the Grafana username and password used (`admin:admin`).

The Helm release installs the [Grafana](https://github.com/grafana/helm-charts/tree/main/charts/grafana) Helm chart.

After `terraform apply` runs, you can access the console via your web browser. The `grafana_url` output contains the hyperlink to access the console. You can also invoke the following command to retrieve the hyperlink value:

```bash
terraform output grafana_url
```

## License

[MIT License](LICENSE)
