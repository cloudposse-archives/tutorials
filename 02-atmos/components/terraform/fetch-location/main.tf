
# Invoke an our fetch_location.sh external program to get information on the
# client's IP Address.
data "external" "fetch_location" {
  program = ["bash", "${path.root}/fetch_location.sh"]
}

# Locals for building the outputs
locals {
  location_map = data.external.fetch_location.result
  location_str = "${local.location_map.city}, ${local.location_map.region}, ${local.location_map.country}"
}

output "users_location_map" {
  value = local.location_map
}

output "users_location" {
  value = local.location_str
}
