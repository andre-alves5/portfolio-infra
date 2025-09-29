variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "kubernetes_version" {
  type        = string
  description = "EKS control plane version (e.g., 1.33, 1.32)"
  default     = "1.33"
}

variable "endpoint_private_access" {
  type        = bool
  default     = true
  description = "Enable private access to the EKS API endpoint"
}

variable "endpoint_public_access" {
  type        = bool
  default     = false
  description = "Enable public access to the EKS API endpoint"
}

variable "public_access_cidrs" {
  type        = list(string)
  default     = []
  description = "Allowed CIDRs for public API (ignored when endpoint_public_access=false)"
}

variable "enable_secrets_encryption" {
  type        = bool
  default     = true
  description = "Enable envelope encryption for Kubernetes secrets"
}

variable "kms_key_arn" {
  type        = string
  default     = null
  description = "Existing KMS key ARN for EKS secrets encryption; if null and enable_secrets_encryption=true, a new key is created"
}

variable "tags" {
  type    = map(string)
  default = {}
}
