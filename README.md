<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-vrf/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-vrf/actions/workflows/test.yml)

# Terraform ACI VRF Module

Manages ACI VRF

Location in GUI:
`Tenants` » `XXX` » `Networking` » `VRFs`

## Examples

```hcl
module "aci_vrf" {
  source  = "netascode/vrf/aci"
  version = ">= 0.1.1"

  tenant                                 = "ABC"
  name                                   = "VRF1"
  alias                                  = "VRF1-ALIAS"
  description                            = "My Description"
  enforcement_direction                  = "egress"
  enforcement_preference                 = "unenforced"
  data_plane_learning                    = false
  preferred_group                        = true
  bgp_timer_policy                       = "BGP1"
  bgp_ipv4_address_family_context_policy = "BGP_AF_IPV4"
  bgp_ipv6_address_family_context_policy = "BGP_AF_IPV6"
  dns_labels                             = ["DNS1"]
  contract_consumers                     = ["CON1"]
  contract_providers                     = ["CON1"]
  contract_imported_consumers            = ["I_CON1"]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | VRF name. | `string` | n/a | yes |
| <a name="input_alias"></a> [alias](#input\_alias) | VRF alias. | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | VRF description. | `string` | `""` | no |
| <a name="input_enforcement_direction"></a> [enforcement\_direction](#input\_enforcement\_direction) | VRF enforcement direction. Choices: `ingress`, `egress`. | `string` | `"ingress"` | no |
| <a name="input_enforcement_preference"></a> [enforcement\_preference](#input\_enforcement\_preference) | VRF enforcement preference. Choices: `enforced`, `unenforced`. | `string` | `"enforced"` | no |
| <a name="input_data_plane_learning"></a> [data\_plane\_learning](#input\_data\_plane\_learning) | VRF data plane learning. | `bool` | `true` | no |
| <a name="input_preferred_group"></a> [preferred\_group](#input\_preferred\_group) | VRF preferred group member. | `bool` | `false` | no |
| <a name="input_bgp_timer_policy"></a> [bgp\_timer\_policy](#input\_bgp\_timer\_policy) | VRF BGP timer policy name. | `string` | `""` | no |
| <a name="input_bgp_ipv4_address_family_context_policy"></a> [bgp\_ipv4\_address\_family\_context\_policy](#input\_bgp\_ipv4\_address\_family\_context\_policy) | VRF BGP IPV4 Address Family Context policy name. | `string` | `""` | no |
| <a name="input_bgp_ipv6_address_family_context_policy"></a> [bgp\_ipv6\_address\_family\_context\_policy](#input\_bgp\_ipv6\_address\_family\_context\_policy) | VRF BGP IPV6 Address Family Context policy name. | `string` | `""` | no |
| <a name="input_dns_labels"></a> [dns\_labels](#input\_dns\_labels) | List of VRF DNS labels. | `list(string)` | `[]` | no |
| <a name="input_contract_consumers"></a> [contract\_consumers](#input\_contract\_consumers) | List of contract consumers. | `list(string)` | `[]` | no |
| <a name="input_contract_providers"></a> [contract\_providers](#input\_contract\_providers) | List of contract providers. | `list(string)` | `[]` | no |
| <a name="input_contract_imported_consumers"></a> [contract\_imported\_consumers](#input\_contract\_imported\_consumers) | List of imported contract consumers. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fvCtx` object. |
| <a name="output_name"></a> [name](#output\_name) | VRF name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.dnsLbl](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvCtx](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsBgpCtxPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsCtxToBgpCtxAfPol_ipv4](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsCtxToBgpCtxAfPol_ipv6](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzAny](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzRsAnyToCons](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzRsAnyToConsIf](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzRsAnyToProv](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->