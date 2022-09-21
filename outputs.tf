output "vm_public_ip" {
  value       = azurerm_public_ip.public_ip[0].ip_address
  description = "VM public IP address."
}