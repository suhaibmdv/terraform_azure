terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "vnet" {
  source              = "./modules/vnet"
  vnet_name           = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

module "subnets" {
  source              = "./modules/subnets"
  subnets             = var.subnets
  resource_group_name = azurerm_resource_group.rg.name
  vnet_name           = module.vnet.vnet_name
}

module "nsg" {
  source              = "./modules/nsg"
  nsg_name            = var.nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  security_rules      = var.security_rules
  tags                = var.tags
}

module "route_table" {
  source              = "./modules/route_table"
  route_table_name    = var.route_table_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  routes              = var.routes
  tags                = var.tags
}

module "nat_gateway" {
  source              = "./modules/nat_gateway"
  nat_gateway_name    = var.nat_gateway_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

module "app_gateway" {
  source              = "./modules/app_gateway"
  app_gateway_name    = var.app_gateway_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.subnets.subnet_ids["appgateway"]
  tags                = var.tags
}

module "load_balancer" {
  source              = "./modules/load_balancer"
  lb_name             = var.lb_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

module "vmss" {
  source              = "./modules/vmss"
  vmss_name           = var.vmss_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  vm_size             = var.vm_size
  instance_count      = var.instance_count
  admin_username      = var.admin_username
  ssh_public_key_path = var.ssh_public_key_path
  subnet_id           = module.subnets.subnet_ids["vmss"]
  tags                = var.tags
}

module "aks" {
  source              = "./modules/aks"
  aks_name            = var.aks_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  kubernetes_version  = var.kubernetes_version
  node_count          = var.node_count
  vm_size             = var.aks_vm_size
  subnet_id           = module.subnets.subnet_ids["aks"]
  tags                = var.tags
}
