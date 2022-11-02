variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "VRF name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "alias" {
  description = "VRF alias."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.alias))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "VRF description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "enforcement_direction" {
  description = "VRF enforcement direction. Choices: `ingress`, `egress`."
  type        = string
  default     = "ingress"

  validation {
    condition     = contains(["ingress", "egress"], var.enforcement_direction)
    error_message = "Valid values are `ingress` or `egress`."
  }
}

variable "enforcement_preference" {
  description = "VRF enforcement preference. Choices: `enforced`, `unenforced`."
  type        = string
  default     = "enforced"

  validation {
    condition     = contains(["enforced", "unenforced"], var.enforcement_preference)
    error_message = "Valid values are `enforced` or `unenforced`."
  }
}

variable "data_plane_learning" {
  description = "VRF data plane learning."
  type        = bool
  default     = true
}

variable "preferred_group" {
  description = "VRF preferred group member."
  type        = bool
  default     = false
}

variable "bgp_timer_policy" {
  description = "VRF BGP timer policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.bgp_timer_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "bgp_ipv4_address_family_context_policy" {
  description = "VRF BGP IPV4 Address Family Context policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.bgp_ipv4_address_family_context_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "bgp_ipv6_address_family_context_policy" {
  description = "VRF BGP IPV6 Address Family Context policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.bgp_ipv6_address_family_context_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}


variable "dns_labels" {
  description = "List of VRF DNS labels."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for dns in var.dns_labels : can(regex("^[a-zA-Z0-9_.-]{0,64}$", dns))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "contract_consumers" {
  description = "List of contract consumers."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.contract_consumers : can(regex("^[a-zA-Z0-9_.-]{0,64}$", c))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "contract_providers" {
  description = "List of contract providers."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.contract_providers : can(regex("^[a-zA-Z0-9_.-]{0,64}$", c))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "contract_imported_consumers" {
  description = "List of imported contract consumers."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.contract_imported_consumers : can(regex("^[a-zA-Z0-9_.-]{0,64}$", c))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "pim_enabled" {
  description = "VRF PIM."
  type        = bool
  default     = false
}

variable "pim_mtu" {
  description = "VRF PIM MTU. Allowed values 1-9300."
  type        = number
  default     = 1500

  validation {
    condition     = var.pim_mtu >= 1 && var.pim_mtu <= 9300
    error_message = "Allowed values 1-9300."
  }
}

variable "pim_fast_convergence" {
  description = "VRF PIM fast convergence."
  type        = bool
  default     = false
}

variable "pim_strict_rfc" {
  description = "VRF PIM Strict RFC compliant."
  type        = bool
  default     = false
}

variable "pim_max_multicast_entries" {
  description = "VRF Maximum number of multicast entries. Allowed valued between 1-4294967295."
  type        = number
  default     = 4294967295

  validation {
    condition     = var.pim_max_multicast_entries >= 1 && var.pim_max_multicast_entries <= 4294967295
    error_message = "Allowed valued between 1-4294967295."
  }
}

variable "pim_reserved_multicast_entries" {
  description = "VRF PIM Maximum number of multicast entries. Allowed valued between 0-4294967295."
  type        = string
  default     = "undefined"

  validation {
    condition     = var.pim_reserved_multicast_entries == "undefined" || try(tonumber(var.pim_reserved_multicast_entries) >= 0 && tonumber(var.pim_reserved_multicast_entries) <= 4294967295, false)
    error_message = "Allowed valued between 0-4294967295."
  }
}

variable "pim_resource_policy_multicast_route_map" {
  description = "VRF PIM Resource Policy Multicast Route Map."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.pim_resource_policy_multicast_route_map))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "pim_static_rps" {
  description = "VRF PIM Static RPs."
  type = list(object({
    ip                  = string
    multicast_route_map = optional(string, "")
  }))

  validation {
    condition = alltrue([
      for rp in var.pim_static_rps : can(regex("^[a-zA-Z0-9_.-]{0,64}$", rp.multicast_route_map))
    ])
    error_message = "`multicast_route_map` Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
  default = []
}


variable "pim_fabric_rps" {
  description = "VRF PIM Fabric RPs."
  type = list(object({
    ip                  = string
    multicast_route_map = optional(string, "")
  }))

  validation {
    condition = alltrue([
      for rp in var.pim_fabric_rps : can(regex("^[a-zA-Z0-9_.-]{0,64}$", rp.multicast_route_map))
    ])
    error_message = "`multicast_route_map` Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
  default = []
}
variable "leaked_internal_prefixes" {
  description = "List of leaked internal prefixes. Default value `public`: false."
  type = list(object({
    prefix = string
    public = optional(bool, false)
    destinations = optional(list(object({
      description = optional(string, "")
      tenant      = string
      vrf         = string
      public      = optional(bool)
    })), [])
  }))
  default = []

  validation {
    condition = alltrue(flatten([
      for p in var.leaked_internal_prefixes : [for d in coalesce(p.destinations, []) : can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", d.description))]
    ]))
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue(flatten([
      for p in var.leaked_internal_prefixes : [for d in coalesce(p.destinations, []) : can(regex("^[a-zA-Z0-9_.-]{0,64}$", d.tenant))]
    ]))
    error_message = "`tenant`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue(flatten([
      for p in var.leaked_internal_prefixes : [for d in coalesce(p.destinations, []) : can(regex("^[a-zA-Z0-9_.-]{0,64}$", d.vrf))]
    ]))
    error_message = "`vrf`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "leaked_external_prefixes" {
  description = "List of leaked external prefixes."
  type = list(object({
    prefix             = string
    from_prefix_length = optional(number)
    to_prefix_length   = optional(number)
    destinations = optional(list(object({
      description = optional(string, "")
      tenant      = string
      vrf         = string
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for p in var.leaked_external_prefixes : p.from_prefix_length == null || (p.from_prefix_length >= 0 && p.from_prefix_length <= 128)
    ])
    error_message = "Allowed values `from_prefix_length`: 0-128."
  }

  validation {
    condition = alltrue([
      for p in var.leaked_external_prefixes : p.to_prefix_length == null || (p.to_prefix_length >= 0 && p.to_prefix_length <= 128)
    ])
    error_message = "Allowed values `to_prefix_length`: 0-128."
  }

  validation {
    condition = alltrue(flatten([
      for p in var.leaked_external_prefixes : [for d in coalesce(p.destinations, []) : can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", d.description))]
    ]))
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue(flatten([
      for p in var.leaked_external_prefixes : [for d in coalesce(p.destinations, []) : can(regex("^[a-zA-Z0-9_.-]{0,64}$", d.tenant))]
    ]))
    error_message = "`tenant`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue(flatten([
      for p in var.leaked_external_prefixes : [for d in coalesce(p.destinations, []) : can(regex("^[a-zA-Z0-9_.-]{0,64}$", d.vrf))]
    ]))
    error_message = "`vrf`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}
