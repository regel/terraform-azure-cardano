# Cardano Azure Module

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This repo contains a set of modules in the [modules folder](https://github.com/regel/terraform-azure-cardano/tree/main/modules) for deploying a Cardano node on [Azure](https://portal.azure.com/) using [Terraform](https://www.terraform.io/). 

## Backers :dart: :heart_eyes:

Thank you to all our backers! 🙏 [[Become a backer](https://opencollective.com/gh-regel#backer)]

<a href="https://opencollective.com/gh-regel#backers" target="_blank"><img src="https://opencollective.com/gh-regel/backers.svg?width=890"></a>

## Sponsors :whale:

Support this project by becoming a sponsor. Your logo will show up here with a
link to your website. [[Become a
sponsor](https://opencollective.com/gh-regel#sponsor)]

## Donations in ADA :gem:

Cardano hodlers can send donations to this wallet address: `addr1q973kf48y9vxqareqvxr7flacx3pl3rz0m9lmwt4nej0zr99dw6mre74f2g48nntw5ar6mz58fm09sk70e0k4vgmkess27g47n`

## How to use this Module

This repo has the following folder structure:

* [modules](https://github.com/regel/terraform-azure-cardano/tree/main/modules): This folder contains several standalone, reusable, production-grade modules that you can use to deploy the application.
* [examples](https://github.com/regel/terraform-azure-cardano/tree/main/examples): This folder shows examples of different ways to combine the modules in the `modules` folder to deploy the application.

## What's a Module?

A Module is a canonical, reusable, best-practices definition for how to run a single piece of infrastructure, such 
as a database or server cluster. Each Module is created using [Terraform](https://www.terraform.io/), and
includes automated tests, examples, and documentation. It is maintained both by the open source community and 
companies that provide commercial support. 

Instead of figuring out the details of how to run a piece of infrastructure from scratch, you can reuse 
existing code that has been proven in production. And instead of maintaining all that infrastructure code yourself, 
you can leverage the work of the Module community to pick up infrastructure improvements through
a version number bump.
 
## Code included in this Module:

* [cluster](https://github.com/regel/terraform-azure-cardano/tree/main/modules/cluster): This module installs a Kubernetes cluster in Azure and network security plugins
* [helm-cardano](https://github.com/regel/terraform-azure-cardano/tree/main/modules/helm-cardano): This module installs Kubernetes Helm releases


## How do I contribute to this Module?

Contributions are very welcome! Check out the [Contribution Guidelines](./CONTRIBUTING.md) for instructions.


## How is this Module versioned?

This Module follows the principles of [Semantic Versioning](http://semver.org/). You can find each new release, 
along with the changelog, in the [Releases Page](../../releases). 

During initial development, the major version will be 0 (e.g., `0.x.y`), which indicates the code does not yet have a 
stable API. 
