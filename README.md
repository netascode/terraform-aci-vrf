<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-vrf/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-vrf/actions/workflows/test.yml)

# Terraform ACI VRF Module

Manages ACI VRF

Location in GUI:
`Tenants` » `XXX` » `Networking` » `VRFs`

## Examples

```hcl
module "aci_vrf" {
  source = "netascode/vrf/aci"

  tenant                 = "ABC"
  name                   = "VRF1"
  alias                  = "VRF1-ALIAS"
  description            = "My Description"
  enforcement_direction  = "egress"
  enforcement_preference = "unenforced"
  data_plane_learning    = false
  contracts = {
    consumers          = ["CON1"]
    providers          = ["CON1"]
    imported_consumers = ["I_CON1"]
  }
  bgp_timer_policy = "BGP1"
  dns_labels       = ["DNS1"]
}

```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 0.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 0.2.0 |

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
| <a name="input_contracts"></a> [contracts](#input\_contracts) | VRF contracts. | <pre>object({<br>    consumers          = optional(list(string))<br>    providers          = optional(list(string))<br>    imported_consumers = optional(list(string))<br>  })</pre> | `{}` | no |
| <a name="input_bgp_timer_policy"></a> [bgp\_timer\_policy](#input\_bgp\_timer\_policy) | VRF BGP timer policy name. | `string` | `""` | no |
| <a name="input_dns_labels"></a> [dns\_labels](#input\_dns\_labels) | List of VRF DNS labels. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fvCtx` object. |
| <a name="output_name"></a> [name](#output\_name) | VRF name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest.dnsLbl](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.fvCtx](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.fvRsBgpCtxPol](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.vzAny](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.vzRsAnyToCons](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.vzRsAnyToConsIf](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.vzRsAnyToProv](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
<!-- END_TF_DOCS -->