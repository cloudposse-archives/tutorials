output "domain_name" {
  value       = module.cdn.cf_domain_name
  description = "The FQDN of the created static site."
}

output "s3_bucket_name" {
  value       = module.cdn.s3_bucket
  description = "The FQDN of the created static site."
}
