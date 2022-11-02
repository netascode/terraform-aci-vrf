<!-- BEGIN_TF_DOCS -->
# VRF Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

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
<!-- END_TF_DOCS -->