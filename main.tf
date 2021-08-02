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
  dn         = "${aci_rest.fvCtx.id}/any"
  class_name = "vzAny"
  content = {
    "descr" = ""
  }
}

resource "aci_rest" "vzRsAnyToCons" {
  for_each   = var.contracts.consumers != null ? toset(var.contracts.consumers) : []
  dn         = "${aci_rest.vzAny.id}/rsanyToCons-${each.value}"
  class_name = "vzRsAnyToCons"
  content = {
    "tnVzBrCPName" = each.value
  }
}

resource "aci_rest" "vzRsAnyToProv" {
  for_each   = var.contracts.providers != null ? toset(var.contracts.providers) : []
  dn         = "${aci_rest.vzAny.id}/rsanyToProv-${each.value}"
  class_name = "vzRsAnyToProv"
  content = {
    "tnVzBrCPName" = each.value
  }
}

resource "aci_rest" "vzRsAnyToConsIf" {
  for_each   = var.contracts.imported_consumers != null ? toset(var.contracts.imported_consumers) : []
  dn         = "${aci_rest.vzAny.id}/rsanyToConsIf-${each.value}"
  class_name = "vzRsAnyToConsIf"
  content = {
    "tnVzCPIfName" = each.value
  }
}

resource "aci_rest" "fvRsBgpCtxPol" {
  dn         = "${aci_rest.fvCtx.id}/rsbgpCtxPol"
  class_name = "fvRsBgpCtxPol"
  content = {
    tnBgpCtxPolName = var.bgp_timer_policy
  }
}

resource "aci_rest" "dnsLbl" {
  for_each   = toset(var.dns_labels)
  dn         = "${aci_rest.fvCtx.id}/dnslbl-${each.value}"
  class_name = "dnsLbl"
  content = {
    name = each.value
  }
}
