locals {
  vpc_id              = var.vpc_id
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