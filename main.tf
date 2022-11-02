locals {
  internal_destinations = flatten([
    for prefix in var.leaked_internal_prefixes : [
      for dest in coalesce(prefix.destinations, []) : {
        key = "${prefix.prefix}/${dest.tenant}-${dest.vrf}"
        value = {
          prefix      = prefix.prefix
          tenant      = dest.tenant
          vrf         = dest.vrf
          public      = dest.public
          description = dest.description
        }
      }
    ]
  ])
  external_destinations = flatten([
    for prefix in var.leaked_external_prefixes : [
      for dest in coalesce(prefix.destinations, []) : {
        key = "${prefix.prefix}/${dest.tenant}-${dest.vrf}"
        value = {
          prefix      = prefix.prefix
          tenant      = dest.tenant
          vrf         = dest.vrf
          description = dest.description
        }
      }
    ]
  ])
}

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

resource "aci_rest_managed" "leakRoutes" {
  count      = length(var.leaked_internal_prefixes) > 0 || length(var.leaked_internal_prefixes) > 0 ? 1 : 0
  dn         = "${aci_rest_managed.fvCtx.dn}/leakroutes"
  class_name = "leakRoutes"
}

resource "aci_rest_managed" "leakInternalSubnet" {
  for_each   = { for prefix in var.leaked_internal_prefixes : prefix.prefix => prefix }
  dn         = "${aci_rest_managed.leakRoutes[0].dn}/leakintsubnet-[${each.value.prefix}]"
  class_name = "leakInternalSubnet"
  content = {
    ip    = each.value.prefix
    scope = each.value.public == true ? "public" : "private"
  }
}

resource "aci_rest_managed" "leakTo_internal" {
  for_each   = { for dest in local.internal_destinations : dest.key => dest.value }
  dn         = "${aci_rest_managed.leakInternalSubnet[each.value.prefix].dn}/to-[${each.value.tenant}]-[${each.value.vrf}]"
  class_name = "leakTo"
  content = {
    tenantName = each.value.tenant
    ctxName    = each.value.vrf
    descr      = each.value.description
    scope      = each.value.public == null ? "inherit" : (each.value.public == true ? "public" : "private")
  }
}

resource "aci_rest_managed" "leakExternalPrefix" {
  for_each   = { for prefix in var.leaked_external_prefixes : prefix.prefix => prefix }
  dn         = "${aci_rest_managed.leakRoutes[0].dn}/leakextsubnet-[${each.value.prefix}]"
  class_name = "leakExternalPrefix"
  content = {
    ip = each.value.prefix
    le = each.value.to_prefix_length
    ge = each.value.from_prefix_length
  }
}

resource "aci_rest_managed" "leakTo_external" {
  for_each   = { for dest in local.external_destinations : dest.key => dest.value }
  dn         = "${aci_rest_managed.leakExternalPrefix[each.value.prefix].dn}/to-[${each.value.tenant}]-[${each.value.vrf}]"
  class_name = "leakTo"
  content = {
    tenantName = each.value.tenant
    ctxName    = each.value.vrf
    descr      = each.value.description
  }
}
