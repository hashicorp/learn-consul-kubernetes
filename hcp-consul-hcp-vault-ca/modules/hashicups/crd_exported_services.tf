resource "kubernetes_manifest" "exported_service_product_api" {
  manifest = {
    apiVersion = "consul.hashicorp.com/v1alpha1"
    kind = "ExportedServices"
    metadata = {
      name = "partition-name"
    }
    spec = {
      services = [{
        name = "product-api"
        namespace = "default"
        consumers = [{
          partition = "destinatin-partition-name"
        }]
      }]
    }
  }
}

resource "kubernetes_manifest" "exported_service_postgres" {
  manifest = {
    apiVersion = "consul.hashicorp.com/v1alpha1"
    kind = "ExportedServices"
    metadata = {
      name = "hosted-partition-name"
    }
    spec = {
      services = [{
        name = "postgres"
        namespace = "default"
        consumers = [{
          partition = "destination-partition-name"
        }]
      }]
    }
  }
}