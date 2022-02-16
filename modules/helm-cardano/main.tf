# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  # This module is now only being tested with Terraform 1.0.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 1.0.x code.
  required_version = ">= 0.12.26"
}

resource "random_password" "redis" {
  length           = 24
  special          = true
  override_special = "_%@"
}

resource "helm_release" "csi" {
  count = var.csi_secrets_store_provider_enabled ? 1 : 0

  name             = "csi-secrets-store-provider-azure"
  repository       = "https://raw.githubusercontent.com/Azure/secrets-store-csi-driver-provider-azure/master/charts"
  chart            = "csi-secrets-store-provider-azure"
  version          = var.csi_secrets_store_provider_version
  lint             = true
  namespace        = "kube-system"
  create_namespace = false

  set {
    name  = "secrets-store-csi-driver.syncSecret.enabled"
    value = "true"
  }
}

resource "helm_release" "prometheus" {
  count = var.prometheus_enabled ? 1 : 0

  name             = "prometheus"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "kube-prometheus"
  version          = var.prometheus_version
  lint             = false
  namespace        = var.prometheus_namespace
  create_namespace = true
}

# ---------------------------------------------------------------------------------------------------------------------
# RENDER AND APPLY KUBERNETES CRDs
# ---------------------------------------------------------------------------------------------------------------------

locals {
  redis_auth_name = "${var.namespace}-auth"
}

data "template_file" "redis-auth" {
  template = file("${path.module}/templates/redis-auth.tftpl")
  vars = {
    NAME     = local.redis_auth_name
    PASSWORD = base64encode(random_password.redis.result)
  }
}

resource "null_resource" "redis-auth" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.redis-auth.rendered}")}"
  }

  provisioner "local-exec" {
    working_dir = path.module
    command     = "bash crd.sh"
    interpreter = ["/bin/bash", "-c"]
    environment = {
      KUBECONFIG_RAW = base64encode(var.kube_config_raw)
      MANIFEST_RAW   = base64encode(data.template_file.redis-auth.rendered)
      NAMESPACE      = var.namespace
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# RENDER AND APPLY HELM VALUES
# ---------------------------------------------------------------------------------------------------------------------

data "template_file" "cardano-values" {
  template = file("${path.module}/templates/cardano-values.tftpl")
  vars = {
    IMAGE_TAG               = var.cardano_image_version
    ADMIN_IMAGE_TAG         = coalesce(var.cardano_admin_image_version, var.cardano_image_version)
    METRICS_ENABLED         = var.prometheus_enabled ? "true" : ""
    SERVICE_MONITOR_ENABLED = var.prometheus_enabled ? "true" : ""
    PROMETHEUS_NAMESPACE    = var.prometheus_namespace
    VAULT_CSI_ENABLED       = var.csi_secrets_store_provider_enabled ? "true" : ""
    VAULT_NAME              = var.vault_name
    VAULT_TENANT_ID         = var.tenant_id
    VAULT_CSI_IDENTITY      = var.identity
    DNS_LABEL_NAME          = var.dns_label_name
    ENV                     = var.environment
    PVC_SIZE                = var.pvc_size
    PVC_SOURCE_ENABLED      = var.pvc_source_enabled ? "true" : ""
    PVC_SOURCE_URL          = var.pvc_source_url
    REDIS_EXISTING_SECRET   = local.redis_auth_name
  }
}

resource "helm_release" "cardano" {
  depends_on = [
    helm_release.csi,
    null_resource.redis-auth,
  ]

  name             = var.release_name
  repository       = "https://regel.github.io/cardano-charts"
  chart            = "cardano"
  version          = var.cardano_helm_version
  lint             = true
  namespace        = var.namespace
  create_namespace = true
  wait             = false # do not wait for readiness

  values = [
    data.template_file.cardano-values.rendered,
    var.extra_values
  ]

}

