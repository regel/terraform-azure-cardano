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

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create cluster resources."
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

