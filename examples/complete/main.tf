module "aci_vrf" {
  source  = "netascode/vrf/aci"
  version = ">= 0.1.1"

  tenant                      = "ABC"
  name                        = "VRF1"
  alias                       = "VRF1-ALIAS"
  description                 = "My Description"
  enforcement_direction       = "egress"
  enforcement_preference      = "unenforced"
  data_plane_learning         = false
  preferred_group             = true
  bgp_timer_policy            = "BGP1"
  dns_labels                  = ["DNS1"]
  contract_consumers          = ["CON1"]
  contract_providers          = ["CON1"]
  contract_imported_consumers = ["I_CON1"]
}
