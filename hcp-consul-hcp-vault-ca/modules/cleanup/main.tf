locals {
  vpc_id              = var.vpc_id
  cluster_name        = var.cluster_name
}


resource "null_resource" "cleanup" {
  triggers = {
    # https://github.com/hashicorp/terraform/issues/23679#issuecomment-886020367
    invokes_me_everytime = uuid()
    vpc_id               = local.vpc_id
    region               = var.region
  }

  # LoadBalancers and their pesky ENIs like to stick around for far too long. Clean these up before the rest of the infrastructure is torn down.
  provisioner "local-exec" {
    when        = destroy
    working_dir = path.module
    environment = {
      VPC_ID             = self.triggers.vpc_id
      AWS_DEFAULT_REGION = self.triggers.region
    }
    command     = "bash cleanup.sh"

  }
}

resource "null_resource" "clean_kubeconfig" {
  triggers = {
    invokes_me_everytime  = uuid()
    cluster_name          = local.cluster_name
  }

  provisioner "local-exec" {
    when = destroy
    working_dir = path.module
    command = "kubectl config delete context ${self.triggers.cluster_name}"
  }
}


resource "null_resource" "remove_working_env_tfvars_file" {

  provisioner "local-exec" {
    when = destroy
    working_dir = path.module
    command = "cd ../../working-environment; rm terraform.tfvars"
  }
}