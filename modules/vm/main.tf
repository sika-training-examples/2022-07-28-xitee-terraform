terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.15.1"
    }
  }
}

variable "name" {}

variable "resource_group" {}

variable "public_key" {
  type        = string
  description = "Public SSH key"
}

variable "subnet_id" {
  type = string
}

variable "size" {
  type    = string
  default = "Standard_B2s"
}


resource "azurerm_public_ip" "this" {
  name                = var.name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "this" {
  name                = var.name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this.id
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  name                = var.name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  size                = var.size
  admin_username      = "default"
  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  admin_ssh_key {
    username   = "default"
    public_key = var.public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

output "ip" {
  value = azurerm_public_ip.this.ip_address
}
