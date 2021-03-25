variable "date" {
  default     = null
  type        = string
  description = "The date to retrieve weather data for."
}

data "terraform_remote_state" "location" {
  backend = "local"

  config = {
    path = "${path.root}/../fetch-location/terraform.tfstate.d/example/terraform.tfstate"
  }
}

locals {
  users_location_map = data.terraform_remote_state.location.outputs.users_location_map

  lat = local.users_location_map.lat
  lon = local.users_location_map.lon

  location_url = "https://www.metaweather.com/api/location/search/?lattlong=${local.lat},${local.lon}"

  location_id      = local.location_data[0].woeid
  weather_base_url = "https://www.metaweather.com/api/location"
  weather_url      = var.date != null ? "${local.weather_base_url}/${local.location_id}/${var.date}" : "${local.weather_base_url}/${local.location_id}/"

  location_data     = jsondecode(data.http.fetch_location.body)
  full_weather_data = jsondecode(data.http.fetch_weather.body)

  selected_weather_data = var.date != null ? local.full_weather_data[0] : local.full_weather_data.consolidated_weather[0]
}

data "http" "fetch_location" {
  url = local.location_url

  request_headers = {
    Accept = "application/json"
  }
}

data "http" "fetch_weather" {
  url = local.weather_url

  request_headers = {
    Accept = "application/json"
  }
}

output "location_data" {
  value = local.location_data
}

output "weather_data" {
  value = local.selected_weather_data
}
