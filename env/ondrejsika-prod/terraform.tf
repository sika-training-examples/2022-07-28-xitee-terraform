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
    key                  = "ondrejsika-prod.tfstate"
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

module "example-infra" {
  source = "../../apps/example-infra"

  prefix = "prod"
}

output "example-infra" {
  value     = module.example-infra
  sensitive = true
}
