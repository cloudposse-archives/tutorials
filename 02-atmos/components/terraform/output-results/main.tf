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
  weather_start_time  = local.weather_data.startTime
  weather_end_time    = local.weather_data.endTime
  weather_temp        = local.weather_data.temperature
  weather_temp_unit   = local.weather_data.temperatureUnit
  weather_description = local.weather_data.shortForecast
}

data "template_file" "weather_report" {
  template = file("${path.root}/weather-report.tpl")
  vars = {
    users_location      = local.users_location
    weather_temp        = local.weather_temp
    weather_temp_unit   = local.weather_temp_unit
    weather_description = local.weather_description
    weather_start_time  = local.weather_start_time
    weather_end_time    = local.weather_end_time
  }
}

resource "null_resource" "print" {
  count = var.print_users_weather_enabled ? 1 : 0

  triggers = {
    weather_report = data.template_file.weather_report.rendered
  }

  provisioner "local-exec" {
    command = "echo '${data.template_file.weather_report.rendered}'"
  }
}

output "weather_temp" {
  value = local.weather_temp
}

output "weather_description" {
  value = local.weather_description
}

output "weather_date" {
  value = "${local.weather_start_time} through ${local.weather_end_time}"
}

output "weather_report" {
  value = data.template_file.weather_report.rendered
}
