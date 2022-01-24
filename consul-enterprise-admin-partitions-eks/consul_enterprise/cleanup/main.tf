locals {
  vpc_id              = var.vpc_id
  eks_cluster_primary = var.eks_cluster_primary
  eks_cluster_name    = var.eks_cluster_name
  deploy_type         = var.deploy_type
}

resource "null_resource" "cleanup" {
  triggers = {
    # https://github.com/hashicorp/terraform/issues/23679#issuecomment-886020367
    invokes_me_everytime = uuid()
    vpc_id               = local.vpc_id
    eks_cluster_primary  = local.eks_cluster_primary
    eks_cluster_name     = local.eks_cluster_name
    deploy_type          = local.deploy_type
    region               = var.region
  }

  # LoadBalancers and their pesky ENIs like to stick around for far too long. Clean these up before the rest of the infrastructure is torn down.
  provisioner "local-exec" {
    when    = destroy
    working_dir = path.module
    environment = {
      VPC_ID = self.triggers.vpc_id
      AWS_DEFAULT_REGION = self.triggers.region
    }
    command = "bash cleanup-load-balancers.sh"

  }
}