terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.15.1"
    }
  }
}

variable "azurerm_client_id" {}
variable "azurerm_subscription_id" {}
variable "azurerm_tenant_id" {}
variable "client_secret" {}

provider "azurerm" {
  features {}
  client_id       = var.azurerm_client_id
  subscription_id = var.azurerm_subscription_id
  tenant_id       = var.azurerm_tenant_id
  client_secret   = var.client_secret
}

locals {
  DEFAULT_LOCATION = "westeurope"
  SSH_KEY          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCslNKgLyoOrGDerz9pA4a4Mc+EquVzX52AkJZz+ecFCYZ4XQjcg2BK1P9xYfWzzl33fHow6pV/C6QC3Fgjw7txUeH7iQ5FjRVIlxiltfYJH4RvvtXcjqjk8uVDhEcw7bINVKVIS856Qn9jPwnHIhJtRJe9emE7YsJRmNSOtggYk/MaV2Ayx+9mcYnA/9SBy45FPHjMlxntoOkKqBThWE7Tjym44UNf44G8fd+kmNYzGw9T5IKpH1E1wMR+32QJBobX6d7k39jJe8lgHdsUYMbeJOFPKgbWlnx9VbkZh+seMSjhroTgniHjUl8wBFgw0YnhJ/90MgJJL4BToxu9PVnH"
}

resource "azurerm_resource_group" "main" {
  name     = "ondrejsika"
  location = local.DEFAULT_LOCATION
}

resource "azurerm_virtual_network" "main" {
  name                = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "foo" {
  name                = "foo"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "foo" {
  name                = "foo"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.foo.id
  }
}

resource "azurerm_linux_virtual_machine" "foo" {
  name                = "foo"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B2s"
  admin_username      = "default"
  network_interface_ids = [
    azurerm_network_interface.foo.id,
  ]

  admin_ssh_key {
    username   = "default"
    public_key = local.SSH_KEY
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

output "foo-ip" {
  value = azurerm_public_ip.foo.ip_address
}

resource "azurerm_public_ip" "bar" {
  name                = "bar"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "bar" {
  name                = "bar"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bar.id
  }
}

resource "azurerm_linux_virtual_machine" "bar" {
  name                = "bar"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B2s"
  admin_username      = "default"
  network_interface_ids = [
    azurerm_network_interface.bar.id,
  ]

  admin_ssh_key {
    username   = "default"
    public_key = local.SSH_KEY
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

output "bar-ip" {
  value = azurerm_public_ip.bar.ip_address
}

module "vm--baz" {
  source = "./modules/vm"

  name           = "baz"
  subnet_id      = azurerm_subnet.default.id
  resource_group = azurerm_resource_group.main
  public_key     = local.SSH_KEY
}

output "baz-ip" {
  value = module.vm--baz.ip
}
