variable "name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}
variable "cluster_name" {
  type    = string
  default = null # when set, we add EKS/ALB discovery tags on subnets
}

variable "tags" {
  type    = map(string)
  default = {}
}
