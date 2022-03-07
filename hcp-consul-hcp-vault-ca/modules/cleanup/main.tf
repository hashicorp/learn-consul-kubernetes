locals {
  vpc_id              = var.vpc_id
  cluster_name        = var.cluster_name
  cleanup             = var.start_cleanup
}


resource "null_resource" "cleanup" {
  triggers = {
    # https://github.com/hashicorp/terraform/issues/23679#issuecomment-886020367
    invokes_me_everytime = uuid()
    vpc_id               = local.vpc_id
    region               = var.region
    cluster_name         = local.cluster_name
    cleanup              = local.cleanup
  }

  # LoadBalancers and their pesky ENIs like to stick around for far too long. Clean these up before the rest of the infrastructure is torn down.
  provisioner "local-exec" {
    when        = destroy
    working_dir = path.module
    environment = {
      VPC_ID             = self.triggers.vpc_id
      AWS_DEFAULT_REGION = self.triggers.region
      CLUSTER_NAME       = self.triggers.cluster_name
      CLEANUP            = self.triggers.cleanup
    }
    command     = "bash cleanup.sh"

  }
}