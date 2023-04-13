locals { 
  vm_name = "${var.base_name}-vm" 
} 
#Create rg
resource "azurerm_resource_group" "vm" {
     name = "${local.vm_name}-rg" 
     location = var.location 

} 
#Create public ip for vm
resource "azurerm_public_ip" "vm" {
  name                = "${local.vm_name}-pip"
  resource_group_name = azurerm_resource_group.vm.name
  location            = azurerm_resource_group.vm.location
  allocation_method   = "Static"
  

  tags = {
    environment = "test"
  }
}
#Create network interface with following parametars
resource "azurerm_network_interface" "vm" {
  name                = "${local.vm_name}-nic"
  location            = azurerm_resource_group.vm.location
  resource_group_name = azurerm_resource_group.vm.name

  ip_configuration {
    name                          = "external"
    subnet_id                     = var.vms_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.vm.id
  }
}

#Create nsg with following parametars and security rules
resource "azurerm_network_security_group" "vm" {
  name                = "${azurerm_network_interface.vm.name}-nsg"
  location            = azurerm_resource_group.vm.location
  resource_group_name = azurerm_resource_group.vm.name

  security_rule {
    name                       = "allow_ssh_from_my_ip"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.my_public_ip
    destination_address_prefix = "*"
  }
   security_rule {
    name                       = "allow_http_from_my_ip"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = var.my_public_ip
    destination_address_prefix = "*"
  }


  tags = {
    environment = "test"
  }
}
#Create association(connection) bettween nic and nsg
resource "azurerm_network_interface_security_group_association" "vm" {
  network_interface_id      = azurerm_network_interface.vm.id
  network_security_group_id = azurerm_network_security_group.vm.id
}
#Create vm with following parametars
resource "azurerm_linux_virtual_machine" "web_srv" {
  name                = local.vm_name
  resource_group_name = azurerm_resource_group.vm.name
  location            = azurerm_resource_group.vm.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  admin_password      = var.my_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.vm.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}


