data "aws_region" "current" {}
variable "eks_cluster_name" {}
variable "deploy_type" {}
variable "eks_cluster_primary" {}

variable "license_name" {}

locals {
  license_content = file("${path.root}/${path.module}/${var.license_name}")
}

resource "null_resource" "install_consul_enterprise" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${data.aws_region.current.name} --name ${var.eks_cluster_name} --alias ${var.eks_cluster_name}"
  }
  # Install the k8s dashboard and EKS Service Accounts
  provisioner "local-exec" {
    command = "kubectl apply -f eks-admin-service-account.yaml"
  }
  # Store consul enterprise license in Kubernetes, any cluster as part of this terraform code will need to upload the license.
  provisioner "local-exec" {
    working_dir = path.module
    command     = "kubectl config use-context ${var.eks_cluster_name} && kubectl create secret generic consul-ent-license --from-literal=\"key=${local.license_content}\""
  }
#  provisioner "local-exec" {
#    working_dir = path.module
#    command     = "export CONSUL_PRIMARY=${var.eks_cluster_primary}; export CURRENT_KUBE_CONTEXT=${var.eks_cluster_name}; export CONSUL_DEPLOY_TYPE=${var.deploy_type}; bash ./install_consul.sh"
#  }
#
#  provisioner "local-exec" {
#    command = "bash ./consul_enterprise/install_certs.sh"
#  }
#
#  provisioner "local-exec" {
#    when = destroy
#    # This solves an issue where k8s deploys an AWS resource (ELB) that terraform can't control and will error out the destroy command
#    command = "kubectl get services --all-namespaces | grep -vi kube | grep -i LoadBalancer | awk {'print $1'} | sed -n '1d;p' | xargs kubectl delete services"
#  }
  #  provisioner "local-exec" {
  #    when = destroy
  #    # This solves an issue where k8s deploys an AWS resource (ELB) that terraform can't control and will error out the destroy command
  #    command = "kubectl get deployments --all-namespaces | grep -v consul  | grep -v kube-system| awk {'print $1'} | sed -n '1d;p' | xargs kubectl delete deployments"
  #  }

}