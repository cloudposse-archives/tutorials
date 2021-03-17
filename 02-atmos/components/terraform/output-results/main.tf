variable "print_users_weather_enabled" {
  default     = false
  type        = bool
  description = "Whether or not to pretty print the weather results"
}

data "terraform_remote_state" "weather" {
  backend = "local"

  config = {
    path = "${path.root}/../fetch-weather/terraform.tfstate.d/example/terraform.tfstate"
  }
}

data "terraform_remote_state" "location" {
  backend = "local"

  config = {
    path = "${path.root}/../fetch-location/terraform.tfstate.d/example/terraform.tfstate"
  }
}

locals {
  users_location = data.terraform_remote_state.location.outputs.users_location

  weather_data        = data.terraform_remote_state.weather.outputs.weather_data
  weather_temp        = local.weather_data.main.temp
  weather_description = local.weather_data.weather[0].description
}

resource "null_resource" "print" {
  count = var.print_users_weather_enabled ? 1 : 0

  triggers = {
    "temp"        = local.weather_temp
    "description" = local.weather_description
  }

  provisioner "local-exec" {
    command = <<-EOT
    printf "


    === Your Weather Report ===
    ============================
    Location: ${local.users_location}
    Temperature: ${local.weather_temp}°
    Weather: ${local.weather_description}
    ============================


    "
    EOT
  }
}

output "weather_temp" {
  value = local.weather_temp
}

output "weather_description" {
  value = local.weather_description
}
