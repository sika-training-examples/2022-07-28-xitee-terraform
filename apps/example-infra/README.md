## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.15.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.15.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vm--bar"></a> [vm--bar](#module\_vm--bar) | ../../modules/vm | n/a |
| <a name="module_vms--ci"></a> [vms--ci](#module\_vms--ci) | ../../modules/vm | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/3.15.1/docs/resources/resource_group) | resource |
| [azurerm_subnet.default](https://registry.terraform.io/providers/hashicorp/azurerm/3.15.1/docs/resources/subnet) | resource |
| [azurerm_virtual_network.main](https://registry.terraform.io/providers/hashicorp/azurerm/3.15.1/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bar-ip"></a> [bar-ip](#output\_bar-ip) | n/a |
| <a name="output_ci-ip"></a> [ci-ip](#output\_ci-ip) | n/a |
