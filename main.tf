data "azurerm_virtual_network" "vnet" {
  name = var.vm_vnet
}

data "azurerm_subnet" "subnet" {
  name                 = var.vm_subnet
  virtual_network_name = var.vm_vnet
}

resource "azurerm_public_ip" "public_ip" {
  count               = var.create_public_ip ? 1 : 0
  name                = var.vm_name
  resource_group_name = var.resource_group
  location            = data.azurerm_virtual_network.vnet.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "interface" {
  name                = "${vm_name}-nic"
  location            = data.azurerm_virtual_network.vnet.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.id
    private_ip_address_allocation = var.private_ip != "" ? "Static" : "Dynamic"
    private_ip_address            = var.private_ip != "" ? var.private_ip : null
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.vm_name
  location            = data.azurerm_virtual_network.vnet.location
  resource_group_name = var.resource_group
}

resource "azurerm_network_security_rule" "nsg_rule" {
  for_each                    = var.vm_network_rules
  name                        = each.value.priority
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port
  destination_port_range      = each.value.dest_port
  source_address_prefix       = each.value.source_ip
  destination_address_prefix  = each.value.dest_ip
  resource_group_name         = var.resource_group
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.vm_name
  resource_group_name             = var.resource_group
  location                        = data.azurerm_virtual_network.location
  network_interface_ids           = [azurerm_network_interface.interface.id]
  size                            = var.vm_size
  admin_username                  = var.vm_username
  admin_password                  = var.vm_password
  disable_password_authentication = true
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
