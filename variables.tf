variable "resource_group" {
  type        = string
  default     = ""
  description = "Name of the resource group to deploy VM resources to."
}

variable "vm_name" {
  type        = string
  default     = "vm"
  description = "Name of the Azure Virtual Machine."
}

variable "vm_vnet" {
  type        = string
  default     = ""
  description = "Name of the Azure VNet to place VM into."
}

variable "vm_subnet" {
  type        = string
  default     = ""
  description = "Name of the Azure subnet to place VM into."
}

variable "vm_network_rules" {
  type = list(object({
    priority = number
    protocol = string
    source_ip = string
    dest_ip = string
    source_port = string
    dest_port = string
    direction = string
    access = string
  }))
  default = [
    {
      priority    = 100
      protocol    = "Tcp"
      source_ip   = "0.0.0.0/0"
      dest_ip     = "0.0.0.0/0"
      source_port = "*"
      dest_port   = "22"
      direction   = "Inbound"
      access      = "Allow"
    }
  ]
}

variable "vm_size" {
  type        = string
  default     = "Standard_B1ms"
  description = "The size of the Azure VM resource."
}

variable "vm_username" {
  type        = string
  default     = "adminuser"
  description = "The username of the local VM user account."
}

variable "vm_password" {
  type        = string
  default     = ""
  description = "The password for the local VM user account."
}

variable "image_publisher" {
  type        = string
  default     = "Canonical"
  description = "VM image publisher."
}

variable "image_offer" {
  type        = string
  default     = "0001-com-ubuntu-server-focal"
  description = "VM image offer."
}

variable "image_sku" {
  type        = string
  default     = "20_04-lts-gen2"
  description = "VM image sku."
}

variable "image_version" {
  type        = string
  default     = "latest"
  description = "VM image version."
}

variable "create_public_ip" {
  type        = bool
  default     = false
  description = "Specify if public IP should be created for Azure VM's network interface."
}
