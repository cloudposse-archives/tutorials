#!/usr/bin/env bash
#
# Since we're creating an S3 bucket as part of this tutorial, we need the names of those
# buckets to be unique, otherwise we'll run into issues with AWS S3 API errors blocking
# our terraform applies. This scripts generates random pet names to append to attributes
# which ensures all bucket names in the project are unique.

# Build random value
# We install golang-petname as part of our tutorials toolbox.
RANDOM_PET=$(golang-petname)

# Updates our tfstate-backend's attributes to be unique
yq eval --inplace \
    ".components.terraform.tfstate-backend.vars.attributes.[0] = \"$RANDOM_PET\"" \
    stacks/ue2-root.yaml

# Updates our static backend config with unique names
yq eval --inplace \
    ".terraform.backend.s3.bucket = \"acme-uw2-tfstate-$RANDOM_PET\"" \
    stacks/catalog/globals.yaml

yq eval --inplace \
    ".terraform.backend.s3.dynamodb_table = \"acme-uw2-tfstate-lock-$RANDOM_PET\"" \
    stacks/catalog/globals.yaml

# Updates our dev + prod static-site component vars to ensure we're creating unique names
yq eval --inplace \
    ".components.terraform.static-site.vars.attributes.[0] = \"$RANDOM_PET\"" \
    stacks/uw2-dev.yaml

yq eval --inplace \
    ".components.terraform.static-site.vars.attributes.[0] = \"$RANDOM_PET\"" \
    stacks/uw2-prod.yaml
