variable "vault_name" {
  type        = string
  description = "(Required) Name of the Azure Key Vault."
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create vault resources."
}

variable "tenant_id" {
  type        = string
  description = "(Required) To get the tenant ID, select Properties for your Azure AD tenant."
}

variable "allow_subnet_ids" {
  type        = list(string)
  description = "List of subnets granted permission to read secrets in Azure Key Vault."
  default     = []
}

variable "cluster_principal_id" {
  type        = string
  description = "Principal identity of the Kubernetes cluster that requires access to Azure Key Vault."
}

variable "kubelet_principal_id" {
  type        = string
  description = "Principal identity of the Kubernetes kubelet that requires access to Azure Key Vault."
}

variable "sku_name" {
  type        = string
  description = "The Name of the SKU used for this Key Vault. Possible values are standard and premium."
  default     = "standard"
}

variable "allow_cidrs" {
  type        = list(string)
  description = "One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault."
  default     = []
}

variable "allow_azuread_group" {
  type        = bool
  description = "Grant Azure Key Vault read-write permissions to the given AAD group."
  default     = false
}

# FIXME: use for_each
variable "azuread_group_principal_id" {
  type        = string
  description = "Principal identity of the AAD group"
  default     = ""
}
