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
  count      = var.ipv4_address_family_context_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.fvCtx.dn}/rsctxToBgpCtxAfPol-${var.ipv4_address_family_context_policy}-ipv4-ucast"
  class_name = "fvRsCtxToBgpCtxAfPol"
  content = {
    af                = "ipv4-ucast"
    tnBgpCtxAfPolName = var.ipv4_address_family_context_policy
  }
}

resource "aci_rest_managed" "fvRsCtxToBgpCtxAfPol_ipv6" {
  count      = var.ipv6_address_family_context_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.fvCtx.dn}/rsctxToBgpCtxAfPol-${var.ipv6_address_family_context_policy}-ipv6-ucast"
  class_name = "fvRsCtxToBgpCtxAfPol"
  content = {
    af                = "ipv6-ucast"
    tnBgpCtxAfPolName = var.ipv6_address_family_context_policy
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
