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
  version = ">= 0.0.2"

  tenant                      = "ABC"
  name                        = "VRF1"
  alias                       = "VRF1-ALIAS"
  description                 = "My Description"
  enforcement_direction       = "egress"
  enforcement_preference      = "unenforced"
  data_plane_learning         = false
  bgp_timer_policy            = "BGP1"
  dns_labels                  = ["DNS1"]
  contract_consumers          = ["CON1"]
  contract_providers          = ["CON1"]
  contract_imported_consumers = ["I_CON1"]
}

```
<!-- END_TF_DOCS -->