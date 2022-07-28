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
}

resource "azurerm_resource_group" "main" {
  name     = "ondrejsika"
  location = local.DEFAULT_LOCATION
}
