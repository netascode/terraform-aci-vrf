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

variable "contracts" {
  description = "VRF contracts."
  type = object({
    consumers          = optional(list(string))
    providers          = optional(list(string))
    imported_consumers = optional(list(string))
  })
  default = {}

  validation {
    condition = alltrue([
      for con in coalesce(var.contracts.consumers, []) : can(regex("^[a-zA-Z0-9_.-]{0,64}$", con))
    ])
    error_message = "`consumers`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for prov in coalesce(var.contracts.providers, []) : can(regex("^[a-zA-Z0-9_.-]{0,64}$", prov))
    ])
    error_message = "`providers`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for imp in coalesce(var.contracts.imported_consumers, []) : can(regex("^[a-zA-Z0-9_.-]{0,64}$", imp))
    ])
    error_message = "`imported_consumers`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
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


