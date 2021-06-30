module "vm-image" {
  source   = "./gce/vm-image"
  for_each = var.environments

  prefix       = each.key
  vm_image     = lookup(each.value, "vm_image", var.vm_image)
  project      = lookup(each.value, "project", var.project)
  machine_type = lookup(each.value, "machine_type", var.machine_type)
  zone         = lookup(each.value, "zone", var.zone)
}

module "vm-replica" {
  source   = "./gce/vm-replica"
  for_each = var.environments

  prefix               = each.key
  project              = lookup(each.value, "project", var.project)
  machine_type         = lookup(each.value, "machine_type", var.machine_type)
  zone                 = lookup(each.value, "zone", var.zone)
  num_instances        = lookup(each.value, "num_instances", var.num_instances)
  source_machine_image = module.vm-image[each.key].gce_vm_name
}

module "eks-cluster" {
  source   = "./aws/eks"
  for_each = var.eks_clusters

  prefix             = each.key
  num_instances      = lookup(each.value, "num_instances", var.num_instances)
  azs_controlplane   = lookup(each.value, "azs_controlplane", var.azs_controlplane)
  azs_workers        = lookup(each.value, "azs_workers", var.azs_workers)
  eks_version        = lookup(each.value, "eks_version", var.eks_version)
  node_instance_type = lookup(each.value, "node_instance_type", var.node_instance_type)
}