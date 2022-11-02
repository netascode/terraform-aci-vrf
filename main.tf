resource "aci_rest_managed" "fvCtx" {
  dn         = "uni/tn-${var.tenant}/ctx-${var.name}"
  class_name = "fvCtx"
  content = {
    "name"                = var.name
    "nameAlias"           = var.alias
    "descr"               = var.description
    "ipDataPlaneLearning" = var.data_plane_learning == true ? "enabled" : "disabled"
    "pcEnfDir"            = var.enforcement_direction
    "pcEnfPref"           = var.enforcement_preference
  }
}

resource "aci_rest_managed" "vzAny" {
  dn         = "${aci_rest_managed.fvCtx.dn}/any"
  class_name = "vzAny"
  content = {
    "descr"      = ""
    "prefGrMemb" = var.preferred_group == true ? "enabled" : "disabled"
  }
}

resource "aci_rest_managed" "vzRsAnyToCons" {
  for_each   = toset(var.contract_consumers)
  dn         = "${aci_rest_managed.vzAny.dn}/rsanyToCons-${each.value}"
  class_name = "vzRsAnyToCons"
  content = {
    "tnVzBrCPName" = each.value
  }
}

resource "aci_rest_managed" "vzRsAnyToProv" {
  for_each   = toset(var.contract_providers)
  dn         = "${aci_rest_managed.vzAny.dn}/rsanyToProv-${each.value}"
  class_name = "vzRsAnyToProv"
  content = {
    "tnVzBrCPName" = each.value
  }
}

resource "aci_rest_managed" "vzRsAnyToConsIf" {
  for_each   = toset(var.contract_imported_consumers)
  dn         = "${aci_rest_managed.vzAny.dn}/rsanyToConsIf-${each.value}"
  class_name = "vzRsAnyToConsIf"
  content = {
    "tnVzCPIfName" = each.value
  }
}

resource "aci_rest_managed" "fvRsBgpCtxPol" {
  dn         = "${aci_rest_managed.fvCtx.dn}/rsbgpCtxPol"
  class_name = "fvRsBgpCtxPol"
  content = {
    tnBgpCtxPolName = var.bgp_timer_policy
  }
}

resource "aci_rest_managed" "fvRsCtxToBgpCtxAfPol_ipv4" {
  count      = var.bgp_ipv4_address_family_context_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.fvCtx.dn}/rsctxToBgpCtxAfPol-[${var.bgp_ipv4_address_family_context_policy}]-ipv4-ucast"
  class_name = "fvRsCtxToBgpCtxAfPol"
  content = {
    af                = "ipv4-ucast"
    tnBgpCtxAfPolName = var.bgp_ipv4_address_family_context_policy
  }
}

resource "aci_rest_managed" "fvRsCtxToBgpCtxAfPol_ipv6" {
  count      = var.bgp_ipv6_address_family_context_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.fvCtx.dn}/rsctxToBgpCtxAfPol-[${var.bgp_ipv6_address_family_context_policy}]-ipv6-ucast"
  class_name = "fvRsCtxToBgpCtxAfPol"
  content = {
    af                = "ipv6-ucast"
    tnBgpCtxAfPolName = var.bgp_ipv6_address_family_context_policy
  }
}

resource "aci_rest_managed" "dnsLbl" {
  for_each   = toset(var.dns_labels)
  dn         = "${aci_rest_managed.fvCtx.dn}/dnslbl-${each.value}"
  class_name = "dnsLbl"
  content = {
    name = each.value
  }
}

resource "aci_rest_managed" "pimCtxP" {
  count      = var.pim_enabled == true ? 1 : 0
  dn         = "${aci_rest_managed.fvCtx.dn}/pimctxp"
  class_name = "pimCtxP"
  content = {
    mtu  = var.pim_mtu
    ctrl = join(",", concat(var.pim_fast_convergence == true ? ["fast-conv"] : [], var.pim_strict_rfc == true ? ["strict-rfc-compliant"] : []))
  }
}

resource "aci_rest_managed" "pimResPol" {
  count      = var.pim_enabled == true ? 1 : 0
  dn         = "${aci_rest_managed.pimCtxP[0].dn}/res"
  class_name = "pimResPol"
  content = {
    max  = var.pim_max_multicast_entries
    rsvd = var.pim_reserved_multicast_entries
  }
}

resource "aci_rest_managed" "rtdmcRsFilterToRtMapPol" {
  count      = var.pim_enabled == true && var.pim_resource_policy_multicast_route_map != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimResPol[0].dn}/rsfilterToRtMapPol"
  class_name = "rtdmcRsFilterToRtMapPol"
  content = {
    tDn = "uni/tn-${var.tenant}/rtmap-${var.pim_resource_policy_multicast_route_map}"
  }
}

resource "aci_rest_managed" "pimStaticRPPol" {
  count      = var.pim_enabled == true ? 1 : 0
  dn         = "${aci_rest_managed.pimCtxP[0].dn}/staticrp"
  class_name = "pimStaticRPPol"
}

resource "aci_rest_managed" "pimStaticRPEntryPol_static_rp" {
  for_each   = { for rp in var.pim_static_rps : rp.ip => rp if var.pim_enabled == true }
  dn         = "${aci_rest_managed.pimStaticRPPol[0].dn}/staticrpent-[${each.value.ip}]"
  class_name = "pimStaticRPEntryPol"
  content = {
    rpIp = each.value.ip
  }
}

resource "aci_rest_managed" "pimRPGrpRangePol_static_rp" {
  for_each   = { for rp in var.pim_static_rps : rp.ip => rp if var.pim_enabled == true && rp.multicast_route_map != "" }
  dn         = "${aci_rest_managed.pimStaticRPEntryPol_static_rp[each.value.ip].dn}/rpgrprange"
  class_name = "pimRPGrpRangePol"
}

resource "aci_rest_managed" "rtdmcRsFilterToRtMapPol_static_rp" {
  for_each   = { for rp in var.pim_static_rps : rp.ip => rp if var.pim_enabled == true && rp.multicast_route_map != "" }
  dn         = "${aci_rest_managed.pimRPGrpRangePol_static_rp[each.value.ip].dn}/rsfilterToRtMapPol"
  class_name = "rtdmcRsFilterToRtMapPol"
  content = {
    tDn = "uni/tn-${var.tenant}/rtmap-${each.value.multicast_route_map}"
  }
}

resource "aci_rest_managed" "pimFabricRPPol" {
  count      = var.pim_enabled == true ? 1 : 0
  dn         = "${aci_rest_managed.pimCtxP[0].dn}/fabricrp"
  class_name = "pimFabricRPPol"
}

resource "aci_rest_managed" "pimStaticRPEntryPol_fabric_rp" {
  for_each   = { for rp in var.pim_fabric_rps : rp.ip => rp if var.pim_enabled == true }
  dn         = "${aci_rest_managed.pimFabricRPPol[0].dn}/staticrpent-[${each.value.ip}]"
  class_name = "pimStaticRPEntryPol"
  content = {
    rpIp = each.value.ip
  }
}

resource "aci_rest_managed" "pimRPGrpRangePol_fabric_rp" {
  for_each   = { for rp in var.pim_fabric_rps : rp.ip => rp if var.pim_enabled == true && rp.multicast_route_map != "" }
  dn         = "${aci_rest_managed.pimStaticRPEntryPol_fabric_rp[each.value.ip].dn}/rpgrprange"
  class_name = "pimRPGrpRangePol"
}

resource "aci_rest_managed" "rtdmcRsFilterToRtMapPol_fabric_rp" {
  for_each   = { for rp in var.pim_fabric_rps : rp.ip => rp if var.pim_enabled == true && rp.multicast_route_map != "" }
  dn         = "${aci_rest_managed.pimRPGrpRangePol_fabric_rp[each.value.ip].dn}/rsfilterToRtMapPol"
  class_name = "rtdmcRsFilterToRtMapPol"
  content = {
    tDn = "uni/tn-${var.tenant}/rtmap-${each.value.multicast_route_map}"
  }
}