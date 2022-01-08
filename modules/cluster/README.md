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
