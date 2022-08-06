terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.token 
  #"dop_v1_521fe2e45bb41ccfc3810384faa21a76877113b3a9eca90a36f3cd3892e48a10"
}

resource "digitalocean_kubernetes_cluster" "k8s_iniciativa" {
  name   = var.k8s_name
  #"k8siniciativa"
  region = var.region 
  #"nyc1"
  version = "1.23.9-do.0"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 2
  }
}

resource "digitalocean_kubernetes_node_pool" "node_full" {
  cluster_id = digitalocean_kubernetes_cluster.k8s_iniciativa.id
  name       = "full"
  size       = "s-2vcpu-2gb"
  node_count = 2
}

variable "token" {}
variable "k8s_name" {}
variable "region" {}  

output "kube_endpoint" {
    value = digitalocean_kubernetes_cluster.k8s_iniciativa.endpoint
}

resource "local_file" "kube_config" {
    content  = digitalocean_kubernetes_cluster.k8s_iniciativa.kube_config.0.raw_config
    filename = "kube_config.yaml"
}