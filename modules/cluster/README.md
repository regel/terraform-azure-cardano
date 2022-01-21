# Cluster

This folder contains a [Terraform](https://www.terraform.io/) module to deploy a
[Azure Kubernetes Service](https://azure.microsoft.com/en-us/services/kubernetes-service/) cluster in [Azure](https://portal.azure.com/).


## How do you use this module?

This folder defines a [Terraform module](https://www.terraform.io/docs/modules/usage.html), which you can use in your
code by adding a `module` configuration and setting its `source` parameter to URL of this folder:

```hcl
module "cluster" {
  # TODO: update this to the final URL
  source = "github.com/regel/terraform-azure-cardano//modules/cluster?ref=v0.0.5"


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
| [azurerm_kubernetes_cluster.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_public_ip.aks-ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subnet.internal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | (Required) The Admin Username for the Cluster. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_allow_cidrs"></a> [allow\_cidrs](#input\_allow\_cidrs) | One or more IP Addresses, or CIDR Blocks which should be able to access the Kubernetes API server. | `list(string)` | `[]` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | (Optional) A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created. | `list(string)` | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | (Required) The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_domain_name_label"></a> [domain\_name\_label](#input\_domain\_name\_label) | DNS prefix specified when creating the managed cluster. | `string` | n/a | yes |
| <a name="input_enable_host_encryption"></a> [enable\_host\_encryption](#input\_enable\_host\_encryption) | (Optional) Should the nodes in this Node Pool have host encryption enabled? Defaults to true. | `bool` | `true` | no |
| <a name="input_enable_log_analytics_workspace"></a> [enable\_log\_analytics\_workspace](#input\_enable\_log\_analytics\_workspace) | (Optional) Enables Log Analytics Workspace which the OMS Agent should send data to. | `bool` | `false` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | (Optional) Version of Kubernetes specified when creating the AKS managed cluster. If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade). | `string` | `"1.21.2"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_public_ssh_key"></a> [public\_ssh\_key](#input\_public\_ssh\_key) | (Required) The Public SSH Key used to access the cluster. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create cluster resources. | `string` | n/a | yes |
| <a name="input_system_node_pool_node_count"></a> [system\_node\_pool\_node\_count](#input\_system\_node\_pool\_node\_count) | The initial number of nodes which should exist in this Node Pool. | `number` | `2` | no |
| <a name="input_system_node_pool_vm_size"></a> [system\_node\_pool\_vm\_size](#input\_system\_node\_pool\_vm\_size) | (Optional) The size of the Virtual Machine, such as Standard\_DS2\_v2. | `string` | `"Standard_B2s"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of extra tag blocks added to the configuration. | `map(string)` | `{}` | no |
| <a name="input_user_node_pool_node_count"></a> [user\_node\_pool\_node\_count](#input\_user\_node\_pool\_node\_count) | (Optional) The initial number of nodes which should exist in this Node Pool. | `number` | `1` | no |
| <a name="input_user_node_pool_vm_size"></a> [user\_node\_pool\_vm\_size](#input\_user\_node\_pool\_vm\_size) | (Optional) The size of the Virtual Machine, such as Standard\_DS2\_v2. | `string` | `"Standard_E4s_v4"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_principal_id"></a> [cluster\_principal\_id](#output\_cluster\_principal\_id) | The principal id of the system assigned identity which is used by main components. |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | n/a |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | A kube\_config block |
| <a name="output_kube_config_raw"></a> [kube\_config\_raw](#output\_kube\_config\_raw) | n/a |
| <a name="output_kubelet_client_id"></a> [kubelet\_client\_id](#output\_kubelet\_client\_id) | The Client ID of the user-defined Managed Identity to be assigned to the Kubelets. |
| <a name="output_kubelet_principal_id"></a> [kubelet\_principal\_id](#output\_kubelet\_principal\_id) | The Object ID of the user-defined Managed Identity assigned to the Kubelets. |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | n/a |
| <a name="output_user_subnet_id"></a> [user\_subnet\_id](#output\_user\_subnet\_id) | n/a |
