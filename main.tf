# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A CARDANO NODE IN AZURE
# These templates show an example of how to use the cardano-cluster module to deploy Cardano in Azure. We deploy relay
# and producer pods in the same cluster and secure communication using Calico plugin and network traffic policies.
# ---------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------
terraform {
  # This module is now only being tested with Terraform 1.0.x. However, to make upgrading easier, we are setting
  # 0.14.0 as the minimum version, as that version added support for validation and the alltrue function
  # Removing the validation completely will yield a version compatible with 0.12.26 as that added support for
  # required_providers with source URLs
  required_version = ">= 0.14.0"
}

# ---------------------------------------------------------------------------------------------------------------------
# AUTOMATICALLY LOOK UP THE ACTIVE AZURE SUBSCRIPTION
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_client_config" "current" {
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE KUBERNETES CLUSTER NODES
# ---------------------------------------------------------------------------------------------------------------------
resource "random_pet" "example" {
}
resource "random_string" "number" {
  length  = 7
  special = false
  lower   = false
  upper   = false
  number  = true
}

resource "azurerm_resource_group" "rg" {
  name     = coalesce(var.resource_group_name, random_pet.example.id)
  location = var.location
  tags = merge(
    {
      Name = var.resource_group_name
    },
    var.tags,
  )
}

resource "tls_private_key" "id_rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

locals {
  cluster_name = format("%s%s-cluster", var.env, random_string.number.id)
}

module "cardano_cluster" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "git::git@github.com:regel/terraform-azure-cardano.git//modules/cluster?ref=v0.0.1"
  source = "./modules/cluster"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags
  availability_zones  = var.availability_zones
  allow_cidrs         = []

  cluster_name       = local.cluster_name
  domain_name_label  = coalesce(var.domain_name_label, random_pet.example.id)
  public_ssh_key     = tls_private_key.id_rsa.public_key_openssh
  admin_username     = "azureuser"
  kubernetes_version = "1.21.2"

  system_node_pool_node_count = 1
  system_node_pool_vm_size    = "Standard_DS2_v2"
  user_node_pool_node_count   = 1
  user_node_pool_vm_size      = "Standard_E4s_v4"
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY CONTAINERS IN THE KUBERNETES CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

module "containers" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "git::git@github.com:regel/terraform-azure-cardano.git//modules/helm-cardano?ref=v0.0.1"
  source = "./modules/helm-cardano"

  release_name                       = coalesce(var.release_name, random_pet.example.id)
  namespace                          = var.env
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  dns_label_name                     = coalesce(var.domain_name_label, random_pet.example.id)
  environment                        = var.env
  pvc_size                           = var.pvc_size
  pvc_source_enabled                 = var.pvc_source_enabled
  pvc_source_url                     = var.pvc_source_url
  cardano_helm_version               = var.cardano_helm_version
  cardano_image_version              = var.cardano_image_version
  identity                           = module.cardano_cluster.kubelet_client_id
  csi_secrets_store_provider_enabled = true
  vault_name                         = var.vault_name
  prometheus_enabled                 = false
  prometheus_namespace               = "prometheus"
  kube_config_raw                    = module.cardano_cluster.kube_config_raw

  extra_values = yamlencode({
    relay = {
      resources = {
        limits = {
          cpu    = format("%s", var.max_cpu)
          memory = format("%sGi", var.max_mem_gb)
        }
      }
    }
    producer = {
      resources = {
        limits = {
          cpu    = format("%s", var.max_cpu)
          memory = format("%sGi", var.max_mem_gb)
        }
      }
    }
  })
}

module "vault" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "git::git@github.com:regel/terraform-azure-cardano.git//modules/vault?ref=v0.0.1"
  source = "./modules/vault"

  vault_name           = var.vault_name
  location             = var.location
  resource_group_name  = var.vault_resource_group_name
  tenant_id            = data.azurerm_client_config.current.tenant_id
  allow_subnet_ids     = [module.cardano_cluster.user_subnet_id]
  cluster_principal_id = module.cardano_cluster.cluster_principal_id
  kubelet_principal_id = module.cardano_cluster.kubelet_principal_id
  sku_name             = "standard"
  allow_cidrs          = ["${chomp(data.http.myip.body)}/32"]
  allow_azuread_group  = false
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

