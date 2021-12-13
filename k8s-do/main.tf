terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "asyncapi-k8s-cluster" {
  name    = var.cluster_name
  region  = var.region
  version = var.cluster_version

  node_pool {
    name       = var.cluster_node_pool_name
    size       = var.cluster_node_size
    node_count = var.cluster_node_count
    auto_scale = var.cluster_node_auto_scale
    
    # The following values are only considered if auto_scale is true.
    min_nodes  = var.cluster_node_count
    max_nodes  = var.cluster_node_count_max
  }
}
