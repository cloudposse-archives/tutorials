variable "hourly_forecast" {
  type        = bool
  description = "Whether or not to retrieve hourly weather data"
  default     = false
}

data "terraform_remote_state" "location" {
  backend = "local"

  config = {
    path = "${path.root}/../fetch-location/terraform.tfstate.d/example/terraform.tfstate"
  }
}

locals {
  # Pulls Longitude and Latitude from the Remote State of fetch-location
  users_location_map = data.terraform_remote_state.location.outputs.users_location_map
  lat = local.users_location_map.lat
  lon = local.users_location_map.lon

  # Curls Weather API for Location Data
  location_url = "https://api.weather.gov/points/${local.lat},${local.lon}"
  location_data = jsondecode(data.http.fetch_location.body).properties

  # Curls Weather API for Forecast Data
  weather_url = (var.hourly_forecast) ? local.location_data.forecastHourly : local.location_data.forecast
  weather_data = jsondecode(data.http.fetch_weather.body).properties.periods[0]
}

data "http" "fetch_location" {
  url = local.location_url
}

data "http" "fetch_weather" {
  url = local.weather_url
}

output "location_data" {
  value = local.location_data
}

output "weather_data" {
  value = local.weather_data
}
