terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.15.1"
    }
  }
  backend "azurerm" {
    resource_group_name  = "storage"
    storage_account_name = "xiteedemostates"
    container_name       = "states"
    key                  = "ondrejsika.tfstate"
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
  VM_SMALL = {
    size = "Standard_B2s"
  }
  VM_MEDIUM = {
    size = "Standard_B4ms"
  }
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

module "vm--foo" {
  source = "./modules/vm"

  name           = "foo"
  subnet_id      = azurerm_subnet.default.id
  resource_group = azurerm_resource_group.main
  public_key     = local.SSH_KEY
}

output "foo-ip" {
  value = module.vm--foo.ip
}


module "vm--bar" {
  source = "./modules/vm"

  name           = "bar"
  subnet_id      = azurerm_subnet.default.id
  resource_group = azurerm_resource_group.main
  public_key     = local.SSH_KEY
}

output "bar-ip" {
  value = module.vm--bar.ip
}


module "vms--ci" {
  for_each = {
    "2" = local.VM_MEDIUM
  }

  source = "./modules/vm"

  name           = "ci-${each.key}"
  subnet_id      = azurerm_subnet.default.id
  resource_group = azurerm_resource_group.main
  public_key     = local.SSH_KEY
  size           = each.value.size
}

output "ci-ip" {
  value = {
    for key, val in module.vms--ci :
    key => val.ip
  }
}
