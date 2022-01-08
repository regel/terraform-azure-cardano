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


resource "helm_release" "cardano" {
  depends_on = [
    helm_release.csi,
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
    <<EOF

image:
  tag: "${var.cardano_image_version}"

admin:
  tag: "${coalesce(var.cardano_admin_image_version, var.cardano_image_version)}"

secrets:
  redisUsername: "cardano"

redis:
  auth:
    username: "cardano"

metrics:
  enabled: true
  serviceMonitor:
    enabled: "${var.prometheus_enabled ? true : false}"
    namespace: "${var.prometheus_namespace}"

vault:
  csi:
    enabled: "${var.csi_secrets_store_provider_enabled ? true : false}"
    coldVaultName: "${var.vault_name}"
    hotVaultName: "${var.vault_name}"
    tenantId: "${var.tenant_id}"
    userAssignedIdentityID: "${var.identity}"

service:
  beta.kubernetes.io/azure-dns-label-name: "${var.dns_label_name}"

environment:
  name: "${var.environment}"

persistence:
  enabled: true
  # -- Provide an existing `PersistentVolumeClaim`, the value is evaluated as a template.
  existingClaim:
  mountPath: /data
  # Starting in Kubernetes version 1.21, Kubernetes will use CSI drivers only and by default.
  storageClass: "managed-csi"
  accessModes:
    - ReadWriteOnce
  # -- PVC Storage Request for data volume
  size: "${var.pvc_size}"
  annotations: {}
  selector: {}
  sourceFile:
    enabled: "${var.pvc_source_enabled ? true : false}"
    guid: "${var.pvc_source_guid}"
EOF
  ]

  set_sensitive {
    name  = "secrets.redisPassword"
    value = random_password.redis.result
  }
  set_sensitive {
    name  = "redis.auth.password"
    value = random_password.redis.result
  }
}
