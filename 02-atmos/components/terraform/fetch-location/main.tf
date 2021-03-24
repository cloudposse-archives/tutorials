
# Invoke an the ipapi to get information on the client's IP Address.
data "http" "fetch_location" {
  url = "https://ipwhois.app/json/"
  request_headers = {
    Accept = "application/json"
  }
}

locals {
  location_response = jsondecode(data.http.fetch_location.body)
  location_map = {
    lat     = local.location_response["latitude"],
    lon     = local.location_response["longitude"],
    city    = local.location_response["city"],
    region  = local.location_response["region"],
    country = local.location_response["country_code"],
  }
  location_str = "${local.location_map.city}, ${local.location_map.region}, ${local.location_map.country}"
}

output "users_location_map" {
  value = local.location_map
}

output "users_location" {
  value = local.location_str
}
