# Vault

This folder contains a [Terraform](https://www.terraform.io/) module to deploy a
[Azure Key Vault](https://docs.microsoft.com/en-us/azure/key-vault/general/basic-concepts) in [Azure](https://portal.azure.com/).

## How do you use this module?

This folder defines a [Terraform module](https://www.terraform.io/docs/modules/usage.html), which you can use in your
code by adding a `module` configuration and setting its `source` parameter to URL of this folder:

```hcl
module "vault" {
  # TODO: update this to the final URL
  source = "github.com/regel/terraform-azure-cardano//modules/vault?ref=v0.0.5"


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
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.cardano](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy.admins](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.kubelet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_azuread_group"></a> [allow\_azuread\_group](#input\_allow\_azuread\_group) | Grant Azure Key Vault read-write permissions to the given AAD group. | `bool` | `false` | no |
| <a name="input_allow_cidrs"></a> [allow\_cidrs](#input\_allow\_cidrs) | One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault. | `list(string)` | `[]` | no |
| <a name="input_allow_subnet_ids"></a> [allow\_subnet\_ids](#input\_allow\_subnet\_ids) | List of subnets granted permission to read secrets in Azure Key Vault. | `list(string)` | `[]` | no |
| <a name="input_azuread_group_principal_id"></a> [azuread\_group\_principal\_id](#input\_azuread\_group\_principal\_id) | Principal identity of the AAD group | `string` | `""` | no |
| <a name="input_cluster_principal_id"></a> [cluster\_principal\_id](#input\_cluster\_principal\_id) | Principal identity of the Kubernetes cluster that requires access to Azure Key Vault. | `string` | n/a | yes |
| <a name="input_kubelet_principal_id"></a> [kubelet\_principal\_id](#input\_kubelet\_principal\_id) | Principal identity of the Kubernetes kubelet that requires access to Azure Key Vault. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create vault resources. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The Name of the SKU used for this Key Vault. Possible values are standard and premium. | `string` | `"standard"` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | (Required) To get the tenant ID, select Properties for your Azure AD tenant. | `string` | n/a | yes |
| <a name="input_vault_name"></a> [vault\_name](#input\_vault\_name) | (Required) Name of the Azure Key Vault. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vault_id"></a> [vault\_id](#output\_vault\_id) | n/a |
