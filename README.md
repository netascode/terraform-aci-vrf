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
  version = ">= 0.1.4"

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
  leaked_internal_prefixes = [{
    prefix = "1.1.1.0/24"
    public = true
    destinations = [{
      description = "Leak to VRF2"
      tenant      = "ABC"
      vrf         = "VRF2"
      public      = false
    }]
  }]
  leaked_external_prefixes = [{
    prefix             = "2.2.0.0/16"
    from_prefix_length = 24
    to_prefix_length   = 32
    destinations = [{
      description = "Leak to VRF2"
      tenant      = "ABC"
      vrf         = "VRF2"
    }]
  }]
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
| <a name="provider_aci"></a> [aci](#provider\_aci) | 2.5.2 |

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
| <a name="input_pim_enabled"></a> [pim\_enabled](#input\_pim\_enabled) | VRF PIM. | `bool` | `false` | no |
| <a name="input_pim_mtu"></a> [pim\_mtu](#input\_pim\_mtu) | VRF PIM MTU. Allowed values 1-9300. | `number` | `1500` | no |
| <a name="input_pim_fast_convergence"></a> [pim\_fast\_convergence](#input\_pim\_fast\_convergence) | VRF PIM fast convergence. | `bool` | `false` | no |
| <a name="input_pim_strict_rfc"></a> [pim\_strict\_rfc](#input\_pim\_strict\_rfc) | VRF PIM Strict RFC compliant. | `bool` | `false` | no |
| <a name="input_pim_max_multicast_entries"></a> [pim\_max\_multicast\_entries](#input\_pim\_max\_multicast\_entries) | VRF Maximum number of multicast entries. Allowed valued between 1-4294967295. | `number` | `4294967295` | no |
| <a name="input_pim_reserved_multicast_entries"></a> [pim\_reserved\_multicast\_entries](#input\_pim\_reserved\_multicast\_entries) | VRF PIM Maximum number of multicast entries. Allowed valued between 0-4294967295. | `string` | `"undefined"` | no |
| <a name="input_pim_resource_policy_multicast_route_map"></a> [pim\_resource\_policy\_multicast\_route\_map](#input\_pim\_resource\_policy\_multicast\_route\_map) | VRF PIM Resource Policy Multicast Route Map. | `string` | `""` | no |
| <a name="input_pim_static_rps"></a> [pim\_static\_rps](#input\_pim\_static\_rps) | VRF PIM Static RPs. | <pre>list(object({<br>    ip                  = string<br>    multicast_route_map = optional(string, "")<br>  }))</pre> | `[]` | no |
| <a name="input_pim_fabric_rps"></a> [pim\_fabric\_rps](#input\_pim\_fabric\_rps) | VRF PIM Fabric RPs. | <pre>list(object({<br>    ip                  = string<br>    multicast_route_map = optional(string, "")<br>  }))</pre> | `[]` | no |
| <a name="input_leaked_internal_prefixes"></a> [leaked\_internal\_prefixes](#input\_leaked\_internal\_prefixes) | List of leaked internal prefixes. Default value `public`: false. | <pre>list(object({<br>    prefix = string<br>    public = optional(bool, false)<br>    destinations = optional(list(object({<br>      description = optional(string, "")<br>      tenant      = string<br>      vrf         = string<br>      public      = optional(bool)<br>    })), [])<br>  }))</pre> | `[]` | no |
| <a name="input_leaked_external_prefixes"></a> [leaked\_external\_prefixes](#input\_leaked\_external\_prefixes) | List of leaked external prefixes. | <pre>list(object({<br>    prefix             = string<br>    from_prefix_length = optional(number)<br>    to_prefix_length   = optional(number)<br>    destinations = optional(list(object({<br>      description = optional(string, "")<br>      tenant      = string<br>      vrf         = string<br>    })), [])<br>  }))</pre> | `[]` | no |

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
| [aci_rest_managed.leakExternalPrefix](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.leakInternalSubnet](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.leakRoutes](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.leakTo_external](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.leakTo_internal](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimCtxP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimFabricRPPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimRPGrpRangePol_fabric_rp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimRPGrpRangePol_static_rp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimResPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimStaticRPEntryPol_fabric_rp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimStaticRPEntryPol_static_rp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimStaticRPPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtdmcRsFilterToRtMapPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtdmcRsFilterToRtMapPol_fabric_rp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtdmcRsFilterToRtMapPol_static_rp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzAny](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzRsAnyToCons](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzRsAnyToConsIf](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzRsAnyToProv](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->