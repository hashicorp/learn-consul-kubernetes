variable "number_of_nodes" {
  description = "Number of EKS EC2 nodes to launch within a node group"
  type = map(map(number))
  default = {
    voyager = {
      desired = 2
      max_nodes = 2
      min_nodes = 2
    }
    enterprise = {
      desired = 2
      max_nodes = 2
      min_nodes = 2
    }
  }
}
