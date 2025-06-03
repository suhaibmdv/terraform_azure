# Fixed modules/load_balancer/main.tf
resource "azurerm_public_ip" "lb_ip" {
  name                = "${var.lb_name}-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_lb" "load_balancer" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tags                = var.tags

  frontend_ip_configuration {
    name                 = "frontend-ip-config"
    public_ip_address_id = azurerm_public_ip.lb_ip.id
  }
  
  depends_on = [azurerm_public_ip.lb_ip]
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = "backend-pool"
  
  depends_on = [azurerm_lb.load_balancer]
}

resource "azurerm_lb_probe" "probe" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = "http-probe"
  protocol        = "Http"
  port            = 80
  request_path    = "/"
  interval_in_seconds = 15
  number_of_probes    = 2
  
  depends_on = [azurerm_lb.load_balancer]
}

resource "azurerm_lb_rule" "rule" {
  loadbalancer_id                = azurerm_lb.load_balancer.id
  name                           = "http-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontend-ip-config"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.probe.id
  
  depends_on = [
    azurerm_lb.load_balancer,
    azurerm_lb_backend_address_pool.backend_pool,
    azurerm_lb_probe.probe
  ]
}
