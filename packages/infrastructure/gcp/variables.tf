 variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region to deploy resources (e.g., northamerica-east1)"
  type        = string
  default     = "northamerica-east1"
}

variable "vpc_name" {
  description = "The name of the VPC network"
  type        = string
  default     = "main-vpc"
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
  default     = "main-subnet"
}

variable "subnet_cidr" {
  description = "The CIDR range for the subnet"
  type        = string
  default     = "10.10.0.0/16"
}
