resource "kubernetes_manifest" "service_intention_frontend_to_public_api" {
  manifest = {
    apiVersion = "consul.hashicorp.com/v1alpha1"
    kind = "ServiceIntentions"
    metadata = {
      name = "public-api"
      namespace= "default"
    }
    spec = {
      sources = [{
        name = "frontend"
        action = "allow"
        partition = "partition-name"
      }]
      destination = {
        name = "public-api"
        namespace = "default"
      }
    }
  }
}

resource "kubernetes_manifest" "service_intention_public_api_to_product_api" {
  manifest = {
    apiVersion = "consul.hashicorp.com/v1alpha1"
    kind = "ServiceIntentions"
    metadata = {
      name = "products-api"
      namespace= "default"
    }
    spec = {
      sources = [{
        name = "public-api"
        action = "allow"
        partition = "partition-name"
      }]
      destination = {
        name = "products-api"
        namespace = "default"
      }
    }
  }
}

resource "kubernetes_manifest" "service_intention_public_api_to_payments_service" {
  manifest = {
    apiVersion = "consul.hashicorp.com/v1alpha1"
    kind = "ServiceIntentions"
    metadata = {
      name = "payments"
      namespace= "default"
    }
    spec = {
      sources = [{
        name = "public-api"
        action = "allow"
        partition = "partition-name"
      }]
      destination = {
        name = "products-api"
        namespace = "default"
      }
    }
  }
}

resource "kubernetes_manifest" "service_intention_products_api_to_postgres" {
  manifest = {
    apiVersion = "consul.hashicorp.com/v1alpha1"
    kind = "ServiceIntentions"
    metadata = {
      name = "postgres"
      namespace= "default"
    }
    spec = {
      sources = [{
        name = "public-api"
        action = "allow"
        partition = "partition-name"
      }]
      destination = {
        name = "products-api"
        namespace = "default"
      }
    }
  }
}
