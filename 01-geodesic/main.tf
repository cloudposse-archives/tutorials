data "http" "star_wars" {
  url = "https://swapi.dev/api/people/1"
  request_headers = {
    Accept = "application/json"
  }
}

output "star_wars_data" {
  value       = jsondecode(data.http.star_wars.body)
  description = "Star wars data that we output as part of this simple example project"
}
