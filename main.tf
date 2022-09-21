resource "azurerm_public_ip" "public_ip" {
  count               = var.create_public_ip ? 1 : 0
  name                = var.vm_name
  resource_group_name = var.resource_group
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "interface" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.vm_subnet_id
    private_ip_address_allocation = var.vm_private_ip != "" ? "Static" : "Dynamic"
    private_ip_address            = var.vm_private_ip != "" ? var.vm_private_ip : null
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group
}

resource "azurerm_network_security_rule" "nsg_rule" {
  count                       = length(var.vm_network_rules)
  name                        = var.vm_network_rules[count.index].priority
  priority                    = var.vm_network_rules[count.index].priority
  direction                   = var.vm_network_rules[count.index].direction
  access                      = var.vm_network_rules[count.index].access
  protocol                    = var.vm_network_rules[count.index].protocol
  source_port_range           = var.vm_network_rules[count.index].source_port
  destination_port_range      = var.vm_network_rules[count.index].dest_port
  source_address_prefix       = var.vm_network_rules[count.index].source_ip
  destination_address_prefix  = var.vm_network_rules[count.index].dest_ip
  resource_group_name         = var.resource_group
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.vm_name
  resource_group_name             = var.resource_group
  location                        = var.location
  network_interface_ids           = [azurerm_network_interface.interface.id]
  size                            = var.vm_size
  admin_username                  = var.vm_username
  admin_password                  = var.vm_password
  disable_password_authentication = false
  user_data                       = base64encode(var.user_data)
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}
