terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 3.36.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
   features {}
}
locals { 
  base_name = "${var.my_name}-${var.environment}" 
} 
data "azurerm_subscription" "current" {

}
#Create resource group
resource "azurerm_resource_group" "general_network" {
     name = "${local.base_name}-rg" 
     location = var.location 
}
#Create virtual network
resource "azurerm_virtual_network" "general_network" {
  name                = "${local.base_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.general_network.location # variable taken from rg
  resource_group_name = azurerm_resource_group.general_network.name # variable taken from rg
}
 # Create subnet
resource "azurerm_subnet" "general_network_vms" {
  name                 = "${azurerm_virtual_network.general_network.name}-vms-snet"
  resource_group_name  = azurerm_resource_group.general_network.name
  virtual_network_name = azurerm_virtual_network.general_network.name
  address_prefixes     = ["10.0.1.0/24"]
}
#Call out module for vm
module "vm" {
source = "./vm_module"
base_name = local.base_name
location = var.location
vms_subnet_id = azurerm_subnet.general_network_vms.id
my_public_ip = var.my_public_ip
my_password = var.my_password
}
output "vm_public_ip" {
  value = module.vm.public_ip_address
}
