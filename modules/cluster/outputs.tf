output "kube_config" {
  value       = azurerm_kubernetes_cluster.cluster.kube_config
  description = "A kube_config block"
  # To mark the whole of kube_config as Sensitive in State, set the environment variable ARM_AKS_KUBE_CONFIGS_SENSITIVE to true. Any values from this block used in outputs will then also need to be marked as sensitive.
  sensitive = true
}

output "public_ip" {
  value = azurerm_public_ip.aks-ip.ip_address
}

output "fqdn" {
  value = azurerm_public_ip.aks-ip.fqdn
}

output "user_subnet_id" {
  value = azurerm_subnet.user.id
}

output "cluster_principal_id" {
  value       = azurerm_kubernetes_cluster.cluster.identity[0].principal_id
  description = "The principal id of the system assigned identity which is used by main components."
}

output "kubelet_principal_id" {
  value       = azurerm_kubernetes_cluster.cluster.kubelet_identity[0].object_id
  description = "The Object ID of the user-defined Managed Identity assigned to the Kubelets."
}

output "kubelet_client_id" {
  value       = azurerm_kubernetes_cluster.cluster.kubelet_identity[0].client_id
  description = "The Client ID of the user-defined Managed Identity to be assigned to the Kubelets."
}
