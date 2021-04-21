#!/usr/bin/env bash
#
# Since we're creating an S3 bucket as part of this tutorial, we need the names of those
# buckets to be unique, otherwise we'll run into issues with AWS S3 API errors blocking
# our terraform applies. This scripts uniquifies all bucket names in the project.

# Build random value
RAND=$(golang-petname)
PROD_RAND=$(golang-petname)

# Updates our tfstate-backend's name to be unique
yq eval --inplace \
    ".components.terraform.tfstate-backend.vars.name = \"tfstate-$RAND\"" \
    stacks/ue2-root.yaml

# Updates our static backend config with unique names
yq eval --inplace \
    ".terraform.backend.s3.bucket = \"acme-uw2-tfstate-$RAND\"" \
    stacks/catalog/globals.yaml

yq eval --inplace \
    ".terraform.backend.s3.dynamodb_table = \"acme-uw2-tfstate-$RAND-lock\"" \
    stacks/catalog/globals.yaml

# Updates our dev + prod static-site component vars to ensure we're creating unique names
yq eval --inplace \
    ".components.terraform.static-site.vars.attributes.[0] = \"$RAND\"" \
    stacks/uw2-dev.yaml

yq eval --inplace \
    ".components.terraform.static-site.vars.attributes.[0] = \"$PROD_RAND\"" \
    stacks/uw2-prod.yaml
