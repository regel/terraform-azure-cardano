# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  # This module is now only being tested with Terraform 1.0.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 1.0.x code.
  required_version = ">= 0.12.26"
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY CLUSTER RESOURCES
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_virtual_network" "cluster" {
  name                = format("%s-vnet", var.cluster_name)
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.1.0.0/16"]
  tags = merge(
    {
      Name = var.cluster_name
    },
    var.tags,
  )
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  virtual_network_name = azurerm_virtual_network.cluster.name
  resource_group_name  = var.resource_group_name
  address_prefixes     = ["10.1.0.0/22"]
}

resource "azurerm_subnet" "user" {
  name                 = "user"
  virtual_network_name = azurerm_virtual_network.cluster.name
  resource_group_name  = var.resource_group_name
  address_prefixes     = ["10.1.4.0/22"]
  service_endpoints    = ["Microsoft.KeyVault"]
}


resource "azurerm_public_ip" "aks-ip" {
  name                = format("%s-ip", var.cluster_name)
  location            = var.location
  resource_group_name = azurerm_kubernetes_cluster.cluster.node_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = var.domain_name_label
  tags = merge(
    {
      Name = var.cluster_name
    },
    var.tags,
  )
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                            = var.cluster_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  dns_prefix                      = format("%s-dns", var.domain_name_label)
  kubernetes_version              = var.kubernetes_version
  private_cluster_enabled         = false
  sku_tier                        = "Paid"
  api_server_authorized_ip_ranges = compact(var.allow_cidrs)

  default_node_pool {
    name               = "system"
    node_count         = var.system_node_pool_node_count
    vm_size            = var.system_node_pool_vm_size
    availability_zones = var.availability_zones
    tags = merge(
      {
        Name = var.cluster_name
      },
      var.tags,
    )
    enable_host_encryption       = var.enable_host_encryption
    vnet_subnet_id               = azurerm_subnet.internal.id
    only_critical_addons_enabled = true # ["CriticalAddonsOnly=true:NoSchedule"]
    node_labels = {
      Tier = "internal"
      Type = "OnDemand"
    }
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "calico"
    load_balancer_sku = "standard"
  }

  identity {
    type = "SystemAssigned"
  }

  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = replace(var.public_ssh_key, "\n", "")
    }
  }

  dynamic "addon_profile" {
    for_each = var.enable_log_analytics_workspace ? ["log_analytics"] : []
    content {
      oms_agent {
        enabled                    = true
        log_analytics_workspace_id = azurerm_log_analytics_workspace.main[0].id
      }
    }
  }

  auto_scaler_profile {
    balance_similar_node_groups      = true
    max_graceful_termination_sec     = 300
    scale_down_delay_after_add       = "10m"
    scale_down_delay_after_delete    = "10s"
    scan_interval                    = "10s"
    scale_down_delay_after_failure   = "3m"
    scale_down_unneeded              = "10m"
    scale_down_unready               = "20m"
    scale_down_utilization_threshold = 0.5
  }

  timeouts {
    create = "2h"
    delete = "2h"
    update = "2h"
    read   = "5m"
  }
  tags = merge(
    {
      Name = var.cluster_name
    },
    var.tags,
  )
}


resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                   = "user"
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.cluster.id
  node_count             = var.user_node_pool_node_count
  vm_size                = var.user_node_pool_vm_size
  vnet_subnet_id         = azurerm_subnet.user.id
  availability_zones     = var.availability_zones
  enable_host_encryption = var.enable_host_encryption

  tags = merge(
    {
      Name = var.cluster_name
    },
    var.tags,
  )
}

