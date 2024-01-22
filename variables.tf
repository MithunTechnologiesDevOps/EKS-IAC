variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC Primary CIDR"
}


variable "project_name" {
  type    = string
  default = "MithunTech"
}

variable "environmnet" {
  type    = string
  default = "dev"
}


variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "common_tags" {
  type = map(string)
  default = {
    "Env"     = "Devlopment"
    "Company" = "Mithun Technologies"
  }
}


variable "public_subnets_cidr" {
  type    = list(string)
  default = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
}


variable "private_subnets_cidr" {
  type    = list(string)
  default = ["10.0.96.0/19", "10.0.128.0/19", "10.0.160.0/19"]
}

variable "eks_node_policies" {
  type = set(string)
  default = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
  "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
}


variable "nodegroup_instance_type" {
  type = string
  default = "t2.medium"
}

variable "nodegroup_desired_size" {
  type = number
  default = 1
}

variable "nodegroup_min_size" {
  type = number
  default =  1
}


variable "nodegroup_max_size" {
  type = number
  default = 4
}