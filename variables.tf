# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# ARM_SUBSCRIPTION_ID
# ARM_TENANT_ID
# ARM_CLIENT_ID
# ARM_CLIENT_SECRET

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "vault_name" {
  description = "Name of the Azure Key Vault that contains Cardano pool keys."
  type        = string
}

variable "vault_resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create Azure Key Vault resources. This resource group can differ from the main resource group. This is typically the case if you have a previously deployed (perhaps centrally controlled) Key Vault and Secrets."
}

variable "env" {
  type        = string
  description = "(Required) Environment name: 'testnet' or 'mainnet'"
  default     = "testnet"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create resources."
  default     = "testnet-rg"
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  default     = "West Europe"
}

variable "cluster_name" {
  description = "The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created."
  type        = string
  default     = ""
}

variable "release_name" {
  description = "Release name."
  type        = string
  default     = "testnet"
}

variable "domain_name_label" {
  description = "Set a public-facing DNS label of Cardano relays. This This publishes a fully qualified domain name for the Cardano service using Azure's public DNS servers and top-level domain. The annotation value must be unique within the Azure location, so it's recommended to use a sufficiently qualified label. Azure will then automatically append a default subnet, such as <location>.cloudapp.azure.com (where location is the region you selected), to the name you provide, to create the fully qualified DNS name."
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all Azure resources"
  type        = map(string)
  default     = {}
}

variable "allow_cidrs" {
  type        = list(string)
  description = "One or more IP Addresses, or CIDR Blocks which should be able to access the Kubernetes API server and Azure SQL resources."
  default     = []
}

variable "kubernetes_version" {
  type        = string
  description = "(Optional) Version of Kubernetes specified when creating the AKS managed cluster. If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade)."
  default     = "1.21.2"
}

variable "availability_zones" {
  type        = list(string)
  description = "(Optional) A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created."
  default     = []
}

variable "cardano_helm_version" {
  type        = string
  description = "The Cardano Helm release version to use. See https://github.com/regel/cardano-charts"
  default     = "0.1.3"
}

variable "cardano_image_version" {
  type        = string
  description = "Docker image tag to use for Cardano producer and relay pods."
  default     = "1.35.4"
}

variable "pvc_size" {
  type        = string
  description = "The amount of persistent storage that will be requested for Cardano PVCs. At the time of this writing, the minimum recommended size for mainnet is 64Gi"
  default     = "32Gi"
}

variable "pvc_source_enabled" {
  type        = bool
  description = "Restore blockchain data using the given data source reference."
  default     = false
}

variable "pvc_source_url" {
  type        = string
  description = "URL of a tar.lz4 snapshot of Cardano blockchain data."
  default     = ""
}

variable "max_cpu" {
  type        = number
  description = "cpu resources limits for individual Cardano pods."
  default     = 1
}

variable "max_mem_gb" {
  type        = number
  description = "memory (Gi) resources limits for individual Cardano pods."
  default     = 2
}

