output "dn" {
  value       = aci_rest.fvCtx.id
  description = "Distinguished name of `fvCtx` object."
}

output "name" {
  value       = aci_rest.fvCtx.content.name
  description = "VRF name."
}
