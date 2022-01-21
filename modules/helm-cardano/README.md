# helm-cardano

This folder contains a [Terraform](https://www.terraform.io/) module to deploy all
[Helm](https://github.com/regel/cardano-charts) releases of the application in [Azure](https://portal.azure.com/).


## How do you use this module?

This folder defines a [Terraform module](https://www.terraform.io/docs/modules/usage.html), which you can use in your
code by adding a `module` configuration and setting its `source` parameter to URL of this folder:

```hcl
module "helm-cardano" {
  # TODO: update this to the final URL
  source = "github.com/regel/terraform-azure-cardano//modules/helm-cardano?ref=v0.0.5"


  # ... See variables.tf for the other parameters you must define for the module
}
```

Note the following parameters:

* `source`: Use this parameter to specify the URL of the module. The double slash (`//`) is intentional
  and required. Terraform uses it to specify subfolders within a Git repo (see [module
  sources](https://www.terraform.io/docs/modules/sources.html)). The `ref` parameter specifies a specific Git tag in
  this repo. That way, instead of using the latest version of this module from the `master` branch, which
  will change every time you run Terraform, you're using a fixed version of the repo.


You can find the other parameters in [variables.tf](variables.tf).

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.26 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.cardano](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.csi](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [random_password.redis](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [template_file.cardano-values](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cardano_admin_image_version"></a> [cardano\_admin\_image\_version](#input\_cardano\_admin\_image\_version) | Docker image tag to use for Cardano admin pod. | `string` | `"1.30.1"` | no |
| <a name="input_cardano_helm_version"></a> [cardano\_helm\_version](#input\_cardano\_helm\_version) | The Cardano Helm release version to use. See https://github.com/regel/cardano-charts | `string` | `"0.1.3"` | no |
| <a name="input_cardano_image_version"></a> [cardano\_image\_version](#input\_cardano\_image\_version) | Docker image tag to use for Cardano producer and relay pods. | `string` | `"1.30.1"` | no |
| <a name="input_csi_secrets_store_provider_enabled"></a> [csi\_secrets\_store\_provider\_enabled](#input\_csi\_secrets\_store\_provider\_enabled) | Enable Azure CSI Secret store driver. This driver is required to mount Key Vault secrets in Cardano producer pod and Cardano admin pod. | `bool` | `true` | no |
| <a name="input_csi_secrets_store_provider_version"></a> [csi\_secrets\_store\_provider\_version](#input\_csi\_secrets\_store\_provider\_version) | CSI driver release version. | `string` | `"1.0.0"` | no |
| <a name="input_dns_label_name"></a> [dns\_label\_name](#input\_dns\_label\_name) | (Required) Set a public-facing DNS label of Cardano relays. This This publishes a fully qualified domain name for the Cardano service using Azure's public DNS servers and top-level domain. The annotation value must be unique within the Azure location, so it's recommended to use a sufficiently qualified label. Azure will then automatically append a default subnet, such as <location>.cloudapp.azure.com (where location is the region you selected), to the name you provide, to create the fully qualified DNS name. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the Cardano blockchain network. | `string` | `"testnet"` | no |
| <a name="input_extra_values"></a> [extra\_values](#input\_extra\_values) | (Optional) List of extra values in raw yaml to pass to helm during Cardano install. | `string` | `""` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | Identifier of a user-assigned or system-assigned managed identity. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | (Optional) The namespace to install the release into. Defaults to cardano. | `string` | `"cardano"` | no |
| <a name="input_prometheus_enabled"></a> [prometheus\_enabled](#input\_prometheus\_enabled) | Enable Helm Prometheus release. | `bool` | `true` | no |
| <a name="input_prometheus_namespace"></a> [prometheus\_namespace](#input\_prometheus\_namespace) | (Optional) The namespace to install the prometheus release into. | `string` | `"prometheus"` | no |
| <a name="input_prometheus_version"></a> [prometheus\_version](#input\_prometheus\_version) | kube-prometheus release version. | `string` | `"6.6.0"` | no |
| <a name="input_pvc_size"></a> [pvc\_size](#input\_pvc\_size) | The amount of persistent storage that will be requested for Cardano PVCs. At the time of this writing, the minimum recommended size for mainnet is 64Gi | `string` | `"32Gi"` | no |
| <a name="input_pvc_source_enabled"></a> [pvc\_source\_enabled](#input\_pvc\_source\_enabled) | Restore blockchain data using the given data source reference. | `bool` | `false` | no |
| <a name="input_pvc_source_guid"></a> [pvc\_source\_guid](#input\_pvc\_source\_guid) | Identifier of the Google Drive file containing a tar.gz dump of Cardano blockchain data. | `string` | `""` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | (Required) Release name. | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | (Required) To get the tenant ID, select Properties for your Azure AD tenant. | `string` | n/a | yes |
| <a name="input_vault_name"></a> [vault\_name](#input\_vault\_name) | Name of Azure Key Vault that contains Cardano Hot and Cold keys. | `string` | `""` | no |

## Outputs

No outputs.
