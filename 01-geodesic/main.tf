data "http" "cat_facts" {
  url = "https://catfact.ninja/fact"
  request_headers = {
    Accept = "application/json"
  }
}

output "cat_facts_data" {
  value       = jsondecode(data.http.cat_facts.body)
  description = "Cat Fact data that we output as part of this simple example project"
}
