output "public_ip_address" {
  value = azurerm_linux_virtual_machine.web_srv.public_ip_address
}