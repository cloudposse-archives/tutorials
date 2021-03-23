
# Invoke an the ipapi to get information on the client's IP Address.
data "http" "fetch_location" {
  url = "https://ipapi.co/json/"
  request_headers = {
    Accept = "application/json"
  }
}

locals {
  location_response = jsondecode(data.http.fetch_location.body)
  location_map = {
    city    = local.location_response["city"],
    region  = local.location_response["region_code"],
    country = local.location_response["country"],
  }
  location_str = "${local.location_map.city}, ${local.location_map.region}, ${local.location_map.country}"
}

output "users_location_map" {
  value = local.location_map
}

output "users_location" {
  value = local.location_str
}
