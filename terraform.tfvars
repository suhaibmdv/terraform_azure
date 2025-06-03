resource_group_name = "aks-multi-az-rg"
location            = "Central US"  # Try Central US - often better quota for students
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
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  "allow-https" = {
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  "allow-ssh" = {
    priority                   = 1020
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

route_table_name = "aks-route-table"
routes = {
  "default" = {
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
  }
}

nat_gateway_name = "aks-nat-gateway"
app_gateway_name = "aks-app-gateway"
lb_name          = "aks-load-balancer"
vmss_name        = "aks-vmss"
vm_size          = "Standard_B1s"  # Changed back to B1s (1 vCPU) for quota compliance
instance_count   = 1  # Reduced to 1 instance to save quota
admin_username   = "azureuser"
ssh_public_key_path = "~/.ssh/id_rsa.pub"

aks_name           = "aks-cluster"
kubernetes_version = "1.32.4"
node_count         = 1  # CHANGED: Reduced to 1 node to fit quota (1 vCPU only)
aks_vm_size        = "Standard_B1s"  # CHANGED: Use B1s (1 vCPU) instead of D2s_v3 (2 vCPU)

tags = {
  environment = "development"
  project     = "aks-multi-az"
  owner       = "student"
}
