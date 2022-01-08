variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create cluster resources."
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "cluster_name" {
  type        = string
  description = "(Required) The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created."
}

variable "domain_name_label" {
  type        = string
  description = "DNS prefix specified when creating the managed cluster."
}

variable "kubernetes_version" {
  type        = string
  description = "(Optional) Version of Kubernetes specified when creating the AKS managed cluster. If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade)."
  default     = "1.21.2"
}

variable "system_node_pool_node_count" {
  type        = number
  description = "The initial number of nodes which should exist in this Node Pool."
  default     = 2
}

variable "system_node_pool_vm_size" {
  type        = string
  description = "(Optional) The size of the Virtual Machine, such as Standard_DS2_v2."
  default     = "Standard_B2s"
}

variable "admin_username" {
  type        = string
  description = "(Required) The Admin Username for the Cluster. Changing this forces a new resource to be created."
}

variable "public_ssh_key" {
  type        = string
  description = "(Required) The Public SSH Key used to access the cluster. Changing this forces a new resource to be created."
}

variable "enable_log_analytics_workspace" {
  type        = bool
  description = "(Optional) Enables Log Analytics Workspace which the OMS Agent should send data to."
  default     = false
}

variable "user_node_pool_node_count" {
  type        = number
  description = "(Optional) The initial number of nodes which should exist in this Node Pool."
  default     = 1
}

variable "user_node_pool_vm_size" {
  type        = string
  description = "(Optional) The size of the Virtual Machine, such as Standard_DS2_v2."
  default     = "Standard_E4s_v4"
}

variable "tags" {
  description = "Map of extra tag blocks added to the configuration."
  type        = map(string)
  default     = {}
}

