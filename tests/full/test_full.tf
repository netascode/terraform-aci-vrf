terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "netascode/aci"
      version = ">=0.2.0"
    }
  }
}

resource "aci_rest" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  tenant                      = aci_rest.fvTenant.content.name
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

data "aci_rest" "fvCtx" {
  dn = "uni/tn-${aci_rest.fvTenant.content.name}/ctx-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fvCtx" {
  component = "fvCtx"

  equal "name" {
    description = "name"
    got         = data.aci_rest.fvCtx.content.name
    want        = module.main.name
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest.fvCtx.content.nameAlias
    want        = "VRF1-ALIAS"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest.fvCtx.content.descr
    want        = "My Description"
  }

  equal "ipDataPlaneLearning" {
    description = "ipDataPlaneLearning"
    got         = data.aci_rest.fvCtx.content.ipDataPlaneLearning
    want        = "disabled"
  }

  equal "pcEnfDir" {
    description = "pcEnfDir"
    got         = data.aci_rest.fvCtx.content.pcEnfDir
    want        = "egress"
  }

  equal "pcEnfPref" {
    description = "pcEnfPref"
    got         = data.aci_rest.fvCtx.content.pcEnfPref
    want        = "unenforced"
  }
}

data "aci_rest" "vzRsAnyToCons" {
  dn = "${data.aci_rest.fvCtx.id}/any/rsanyToCons-CON1"

  depends_on = [module.main]
}

resource "test_assertions" "vzRsAnyToCons" {
  component = "vzRsAnyToCons"

  equal "tnVzBrCPName" {
    description = "tnVzBrCPName"
    got         = data.aci_rest.vzRsAnyToCons.content.tnVzBrCPName
    want        = "CON1"
  }
}

data "aci_rest" "vzRsAnyToProv" {
  dn = "${data.aci_rest.fvCtx.id}/any/rsanyToProv-CON1"

  depends_on = [module.main]
}

resource "test_assertions" "vzRsAnyToProv" {
  component = "vzRsAnyToProv"

  equal "tnVzBrCPName" {
    description = "tnVzBrCPName"
    got         = data.aci_rest.vzRsAnyToProv.content.tnVzBrCPName
    want        = "CON1"
  }
}

data "aci_rest" "vzRsAnyToConsIf" {
  dn = "${data.aci_rest.fvCtx.id}/any/rsanyToConsIf-I_CON1"

  depends_on = [module.main]
}

resource "test_assertions" "vzRsAnyToConsIf" {
  component = "vzRsAnyToConsIf"

  equal "tnVzCPIfName" {
    description = "tnVzCPIfName"
    got         = data.aci_rest.vzRsAnyToConsIf.content.tnVzCPIfName
    want        = "I_CON1"
  }
}

data "aci_rest" "fvRsBgpCtxPol" {
  dn = "${data.aci_rest.fvCtx.id}/rsbgpCtxPol"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsBgpCtxPol" {
  component = "fvRsBgpCtxPol"

  equal "tnBgpCtxPolName" {
    description = "tnBgpCtxPolName"
    got         = data.aci_rest.fvRsBgpCtxPol.content.tnBgpCtxPolName
    want        = "BGP1"
  }
}

data "aci_rest" "dnsLbl" {
  dn = "${data.aci_rest.fvCtx.id}/dnslbl-DNS1"

  depends_on = [module.main]
}

resource "test_assertions" "dnsLbl" {
  component = "dnsLbl"

  equal "name" {
    description = "name"
    got         = data.aci_rest.dnsLbl.content.name
    want        = "DNS1"
  }
}
