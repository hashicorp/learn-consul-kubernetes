provider "azurerm" {
  version = "~> 2.0"
  features {}
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

provider "local" {}

resource "azurerm_resource_group" "learn-consul-k8s-rg" {
  count    = var.cluster_count
  name     = "learn-consul-k8s-rg${count.index + 1}"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "learn-consul-k8s-dc" {
  count               = var.cluster_count
  name                = "learn-consul-k8s-dc${count.index + 1}"
  location            = azurerm_resource_group.learn-consul-k8s-rg[count.index].location
  resource_group_name = azurerm_resource_group.learn-consul-k8s-rg[count.index].name
  dns_prefix          = "learn-consul-k8s-${count.index + 1}"
  kubernetes_version  = "1.19.3"

  default_node_pool {
    name            = "default"
    node_count      = 3
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  role_based_access_control {
    enabled = true
  }
}

resource "local_file" "kubeconfigs" {
  count           = var.cluster_count
  content         = azurerm_kubernetes_cluster.learn-consul-k8s-dc[count.index].kube_config_raw
  filename        = pathexpand("~/.kube/learn-consul-k8s-dc${count.index + 1}")
  file_permission = "0600"
}
