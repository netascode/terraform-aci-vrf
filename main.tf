resource "aci_rest" "fvCtx" {
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

resource "aci_rest" "vzAny" {
  dn         = "${aci_rest.fvCtx.dn}/any"
  class_name = "vzAny"
  content = {
    "descr" = ""
  }
}

resource "aci_rest" "vzRsAnyToCons" {
  for_each   = toset(var.contract_consumers)
  dn         = "${aci_rest.vzAny.dn}/rsanyToCons-${each.value}"
  class_name = "vzRsAnyToCons"
  content = {
    "tnVzBrCPName" = each.value
  }
}

resource "aci_rest" "vzRsAnyToProv" {
  for_each   = toset(var.contract_providers)
  dn         = "${aci_rest.vzAny.dn}/rsanyToProv-${each.value}"
  class_name = "vzRsAnyToProv"
  content = {
    "tnVzBrCPName" = each.value
  }
}

resource "aci_rest" "vzRsAnyToConsIf" {
  for_each   = toset(var.contract_imported_consumers)
  dn         = "${aci_rest.vzAny.dn}/rsanyToConsIf-${each.value}"
  class_name = "vzRsAnyToConsIf"
  content = {
    "tnVzCPIfName" = each.value
  }
}

resource "aci_rest" "fvRsBgpCtxPol" {
  dn         = "${aci_rest.fvCtx.dn}/rsbgpCtxPol"
  class_name = "fvRsBgpCtxPol"
  content = {
    tnBgpCtxPolName = var.bgp_timer_policy
  }
}

resource "aci_rest" "dnsLbl" {
  for_each   = toset(var.dns_labels)
  dn         = "${aci_rest.fvCtx.dn}/dnslbl-${each.value}"
  class_name = "dnsLbl"
  content = {
    name = each.value
  }
}
