variable "api_key" {
  type        = string
  description = "The API Key of for the openweathermap.org API"
  sensitive   = true
}

variable "unit_of_measurement" {
  default     = "imperial"
  type        = string
  description = <<-EOT
  The unit of measurement to display the temperature in.
  Valid values are `standard`, `metric`, or `imperial`
  EOT
}

data "terraform_remote_state" "location" {
  backend = "local"

  config = {
    path = "${path.root}/../fetch-location/terraform.tfstate.d/example/terraform.tfstate"
  }
}

locals {
  users_location_map = data.terraform_remote_state.location.outputs.users_location_map

  city    = local.users_location_map.city
  region  = local.users_location_map.region
  country = local.users_location_map.country

  url   = "https://api.openweathermap.org/data/2.5/weather"
  query = "${local.city},${local.region},${local.country}"

  weather_data = jsondecode(data.http.fetch_weather.body)
}

data "http" "fetch_weather" {
  url = "${local.url}?q=${local.query}&appid=${var.api_key}&units=${var.unit_of_measurement}"

  request_headers = {
    Accept = "application/json"
  }
}

output "weather_data" {
  value = local.weather_data
}
