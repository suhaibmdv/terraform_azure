resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.aks_name}-dns"
  kubernetes_version  = var.kubernetes_version
  tags                = var.tags

  default_node_pool {
    name                = "systempool"
    node_count          = var.node_count
    vm_size             = var.vm_size
    zones               = ["1", "2", "3"]
    enable_auto_scaling = true
    min_count           = var.node_count
    max_count           = var.node_count + 2
    vnet_subnet_id      = var.subnet_id
    type                = "VirtualMachineScaleSets"
    os_disk_size_gb     = 30
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
}
