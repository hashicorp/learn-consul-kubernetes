# See note in the triggers map in the null_resource block
locals {
  vpc_id       = var.vpc_id
  cluster_name = var.cluster_name
  cleanup      = var.start_cleanup
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

  # LoadBalancers and associated ENIs can persist during a delete, erroring out. Removes the ENIs and LoadBalancers
  # explicitly before the rest of the infrastructure is removed. Also cleans up kubeconfig setup and the
  # dynamically generated tfvars file in ../../working-environment
  provisioner "local-exec" {
    when        = destroy
    working_dir = path.module
    environment = {
      VPC_ID             = self.triggers.vpc_id
      AWS_DEFAULT_REGION = self.triggers.region
      CLUSTER_NAME       = self.triggers.cluster_name
      CLEANUP            = self.triggers.cleanup
    }
    command = "bash cleanup.sh"

  }
}