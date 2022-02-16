variable "release_name" {
  type        = string
  description = "(Required) Release name."
}

variable "namespace" {
  type        = string
  description = "(Optional) The namespace to install the release into. Defaults to cardano."
  default     = "cardano"
}

variable "tenant_id" {
  type        = string
  description = "(Required) To get the tenant ID, select Properties for your Azure AD tenant."
}

variable "dns_label_name" {
  type        = string
  description = "(Required) Set a public-facing DNS label of Cardano relays. This This publishes a fully qualified domain name for the Cardano service using Azure's public DNS servers and top-level domain. The annotation value must be unique within the Azure location, so it's recommended to use a sufficiently qualified label. Azure will then automatically append a default subnet, such as <location>.cloudapp.azure.com (where location is the region you selected), to the name you provide, to create the fully qualified DNS name."
}

variable "environment" {
  type        = string
  description = "Name of the Cardano blockchain network."
  default     = "testnet"
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
  description = "Url of a tar.gz archive that contains Cardano blockchain database."
  default     = ""
}
variable "cardano_helm_version" {
  type        = string
  description = "The Cardano Helm release version to use. See https://github.com/regel/cardano-charts"
  default     = "0.3.0"
}
variable "cardano_image_version" {
  type        = string
  description = "Docker image tag to use for Cardano producer and relay pods."
  default     = "1.30.1"
}
variable "cardano_admin_image_version" {
  type        = string
  description = "Docker image tag to use for Cardano admin pod."
  default     = "1.30.1"
}

variable "kube_config_raw" {
  type        = string
  description = "A kube_config raw block"
  sensitive   = true
}

variable "identity" {
  type        = string
  description = "Identifier of a user-assigned or system-assigned managed identity."
  default     = null
}

variable "csi_secrets_store_provider_version" {
  type        = string
  description = "CSI driver release version."
  default     = "1.0.0"
}

variable "csi_secrets_store_provider_enabled" {
  type        = bool
  description = "Enable Azure CSI Secret store driver. This driver is required to mount Key Vault secrets in Cardano producer pod and Cardano admin pod."
  default     = true
}

variable "vault_name" {
  type        = string
  description = "Name of Azure Key Vault that contains Cardano Hot and Cold keys."
  default     = ""
}

variable "prometheus_enabled" {
  type        = bool
  description = "Enable Helm Prometheus release."
  default     = true
}

variable "prometheus_version" {
  type        = string
  description = "kube-prometheus release version."
  default     = "6.6.0"
}

variable "prometheus_namespace" {
  type        = string
  description = "(Optional) The namespace to install the prometheus release into."
  default     = "prometheus"
}

variable "extra_values" {
  type        = string
  description = "(Optional) List of extra values in raw yaml to pass to helm during Cardano install."
  default     = ""
}
