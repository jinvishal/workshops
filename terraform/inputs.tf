variable "project" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "zone" {
  type = string
}

variable "region" {
  type = string
}

variable "azs_controlplane" {
  type = list(string)
}

variable "azs_workers" {
  type = list(string)
}

variable "vm_image" {
  type = string
}

variable "num_instances" {
  type = string
}

variable "environments" {
  type    = map(any)
  default = {}
}

variable "eks_clusters" {
  type    = map(any)
  default = {}
}

variable "gke_clusters" {
  type    = map(any)
  default = {}
}

variable "eks_version" {
  type = string
}

variable "node_instance_type" {
  type = string
}

variable "preemptible" {
  type = bool
}

variable "include_vm" {
  type    = map(any)
  default = {}
}

variable "default_region" {
  type = string
}