terraform {
  required_version = ">= 1.0.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = ">=2.0.0"
    }
  }
}

resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  tenant                                 = aci_rest_managed.fvTenant.content.name
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
  pim_enabled                            = true
  pim_mtu                                = 9200
  pim_fast_convergence                   = true
  pim_strict_rfc                         = true
  pim_max_multicast_entries              = 1000
  pim_reserved_multicast_entries         = "undefined"
  pim_static_rps = [
    {
      ip                  = "1.1.1.1"
      multicast_route_map = "TEST_RP"
    },
    {
      ip                  = "1.1.1.2"
      multicast_route_map = "TEST_RP"
    },
  ]
  pim_fabric_rps = [
    {
      ip                  = "2.2.2.1"
      multicast_route_map = "TEST_RP"
    },
    {
      ip                  = "2.2.2.2"
      multicast_route_map = "TEST_RP"
    }
  ]
}

data "aci_rest_managed" "fvCtx" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/ctx-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fvCtx" {
  component = "fvCtx"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fvCtx.content.name
    want        = module.main.name
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.fvCtx.content.nameAlias
    want        = "VRF1-ALIAS"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.fvCtx.content.descr
    want        = "My Description"
  }

  equal "ipDataPlaneLearning" {
    description = "ipDataPlaneLearning"
    got         = data.aci_rest_managed.fvCtx.content.ipDataPlaneLearning
    want        = "disabled"
  }

  equal "pcEnfDir" {
    description = "pcEnfDir"
    got         = data.aci_rest_managed.fvCtx.content.pcEnfDir
    want        = "egress"
  }

  equal "pcEnfPref" {
    description = "pcEnfPref"
    got         = data.aci_rest_managed.fvCtx.content.pcEnfPref
    want        = "unenforced"
  }
}

data "aci_rest_managed" "vzAny" {
  dn = "${data.aci_rest_managed.fvCtx.id}/any"

  depends_on = [module.main]
}

resource "test_assertions" "vzAny" {
  component = "vzAny"

  equal "prefGrMemb" {
    description = "prefGrMemb"
    got         = data.aci_rest_managed.vzAny.content.prefGrMemb
    want        = "enabled"
  }
}

data "aci_rest_managed" "vzRsAnyToCons" {
  dn = "${data.aci_rest_managed.fvCtx.id}/any/rsanyToCons-CON1"

  depends_on = [module.main]
}

resource "test_assertions" "vzRsAnyToCons" {
  component = "vzRsAnyToCons"

  equal "tnVzBrCPName" {
    description = "tnVzBrCPName"
    got         = data.aci_rest_managed.vzRsAnyToCons.content.tnVzBrCPName
    want        = "CON1"
  }
}

data "aci_rest_managed" "vzRsAnyToProv" {
  dn = "${data.aci_rest_managed.fvCtx.id}/any/rsanyToProv-CON1"

  depends_on = [module.main]
}

resource "test_assertions" "vzRsAnyToProv" {
  component = "vzRsAnyToProv"

  equal "tnVzBrCPName" {
    description = "tnVzBrCPName"
    got         = data.aci_rest_managed.vzRsAnyToProv.content.tnVzBrCPName
    want        = "CON1"
  }
}

data "aci_rest_managed" "vzRsAnyToConsIf" {
  dn = "${data.aci_rest_managed.fvCtx.id}/any/rsanyToConsIf-I_CON1"

  depends_on = [module.main]
}

resource "test_assertions" "vzRsAnyToConsIf" {
  component = "vzRsAnyToConsIf"

  equal "tnVzCPIfName" {
    description = "tnVzCPIfName"
    got         = data.aci_rest_managed.vzRsAnyToConsIf.content.tnVzCPIfName
    want        = "I_CON1"
  }
}

data "aci_rest_managed" "fvRsBgpCtxPol" {
  dn = "${data.aci_rest_managed.fvCtx.id}/rsbgpCtxPol"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsBgpCtxPol" {
  component = "fvRsBgpCtxPol"

  equal "tnBgpCtxPolName" {
    description = "tnBgpCtxPolName"
    got         = data.aci_rest_managed.fvRsBgpCtxPol.content.tnBgpCtxPolName
    want        = "BGP1"
  }
}

data "aci_rest_managed" "fvRsCtxToBgpCtxAfPol_ipv4" {
  dn = "${data.aci_rest_managed.fvCtx.id}/rsctxToBgpCtxAfPol-BGP_AF_IPV4-ipv4-ucast"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsCtxToBgpCtxAfPol_ipv4" {
  component = "fvRsCtxToBgpCtxAfPol"

  equal "af" {
    description = "af"
    got         = data.aci_rest_managed.fvRsCtxToBgpCtxAfPol_ipv4.content.af
    want        = "ipv4-ucast"
  }

  equal "tnBgpCtxAfPolName" {
    description = "tnBgpCtxAfPolName"
    got         = data.aci_rest_managed.fvRsCtxToBgpCtxAfPol_ipv4.content.tnBgpCtxAfPolName
    want        = "BGP_AF_IPV4"
  }
}


data "aci_rest_managed" "fvRsCtxToBgpCtxAfPol_ipv6" {
  dn = "${data.aci_rest_managed.fvCtx.id}/rsctxToBgpCtxAfPol-BGP_AF_IPV6-ipv6-ucast"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsCtxToBgpCtxAfPol_ipv6" {
  component = "fvRsCtxToBgpCtxAfPol"

  equal "af" {
    description = "af"
    got         = data.aci_rest_managed.fvRsCtxToBgpCtxAfPol_ipv6.content.af
    want        = "ipv6-ucast"
  }

  equal "tnBgpCtxAfPolName" {
    description = "tnBgpCtxAfPolName"
    got         = data.aci_rest_managed.fvRsCtxToBgpCtxAfPol_ipv6.content.tnBgpCtxAfPolName
    want        = "BGP_AF_IPV6"
  }
}


data "aci_rest_managed" "dnsLbl" {
  dn = "${data.aci_rest_managed.fvCtx.id}/dnslbl-DNS1"

  depends_on = [module.main]
}

resource "test_assertions" "dnsLbl" {
  component = "dnsLbl"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.dnsLbl.content.name
    want        = "DNS1"
  }
}

data "aci_rest_managed" "pimCtxP" {
  dn = "${data.aci_rest_managed.fvCtx.id}/pimctxp"

  depends_on = [module.main]
}

resource "test_assertions" "pimCtxP" {
  component = "pimCtxP"

  equal "mtu" {
    description = "mtu"
    got         = data.aci_rest_managed.pimCtxP.content.mtu
    want        = "9200"
  }

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest_managed.pimCtxP.content.ctrl
    want        = "fast-conv,strict-rfc-compliant"
  }

}


data "aci_rest_managed" "pimResPol" {
  dn = "${data.aci_rest_managed.pimCtxP.id}/res"

  depends_on = [module.main]
}

resource "test_assertions" "pimResPol" {
  component = "pimResPol"

  equal "max" {
    description = "max"
    got         = data.aci_rest_managed.pimResPol.content.max
    want        = "1000"
  }

  equal "rsvd" {
    description = "rsvd"
    got         = data.aci_rest_managed.pimResPol.content.rsvd
    want        = "undefined"
  }

}


