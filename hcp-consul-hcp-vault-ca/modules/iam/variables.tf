variable "cluster_arn" {
  description = "arn to use for a given iam user, role, group or policy"
  type        = string
}

variable "policy_name" {
  type        = string
  description = "Name of the IAM Policy"
}

variable "description" {
  type        = string
  description = "Policy description"
}

variable "role_name" {
  type        = string
  description = "Name of the Role to which a policy is attached"
}

variable "local_policy_file_path" {
  type        = string
  description = "The path of the local policy file in this module"
  default     = "policies/policy.json.tftpl"
}