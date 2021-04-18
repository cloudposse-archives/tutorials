module "cdn" {
  source  = "cloudposse/cloudfront-s3-cdn/aws"
  version = "0.59.0"

  name            = "static-site"
  website_enabled = true

  context = module.this.context
}

resource "aws_s3_bucket_object" "site_index" {
  bucket       = module.cdn.s3_bucket
  key          = "index.html"
  content_type = "text/html"

  content = <<-EOT
  <h1>Hello World!</h1>
  <p>This is ${var.stage}!</p>
  EOT
}
