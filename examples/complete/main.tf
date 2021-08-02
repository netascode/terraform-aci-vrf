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
