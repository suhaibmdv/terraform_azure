resource_group_name = "aks-multi-az-rg"
location            = "eastus"
vnet_name           = "aks-vnet"
vnet_address_space  = ["10.0.0.0/16"]
subnets = {
  "aks"        = { address_prefix = "10.0.1.0/24" }
  "appgateway" = { address_prefix = "10.0.2.0/24" }
  "vmss"       = { address_prefix = "10.0.3.0/24" }
}
nsg_name = "aks-nsg"
security_rules = {
  "allow-http" = {
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
route_table_name = "aks-route-table"
routes = {
  "default" = {
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
    next_hop_in_ip_address = ""
  }
}
nat_gateway_name = "aks-nat-gateway"
app_gateway_name = "aks-app-gateway"
lb_name          = "aks-load-balancer"
vmss_name        = "aks-vmss"
vm_size          = "Standard_DS2_v2"
instance_count   = 3
admin_username   = "azureuser"
ssh_public_key_path = "~/.ssh/id_rsa.pub"
aks_name         = "aks-cluster"
kubernetes_version = "1.28"
node_count       = 3
aks_vm_size      = "Standard_DS2_v2"
tags = {
  environment = "production"
}
